// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SportsBetting {
    struct Bet {
        uint256 id;
        uint256 matchId;
        address bettor;
        uint256 amount;
        uint8 selectedTeam;
    }

    mapping(uint256 => Bet[]) public bets;
    mapping(uint256 => uint8) public matchResults; // Match ID => Winning Team

    event BetPlaced(uint256 betId, uint256 matchId, address bettor, uint256 amount, uint8 team);
    event BetSettled(uint256 betId, uint256 amountWon);

    function placeBet(uint256 _matchId, uint8 _team) public payable {
        require(msg.value > 0, "Bet amount must be greater than 0");
        uint256 betId = bets[_matchId].length;
        bets[_matchId].push(Bet(betId, _matchId, msg.sender, msg.value, _team));
        emit BetPlaced(betId, _matchId, msg.sender, msg.value, _team);
    }

    function settleBets(uint256 _matchId, uint8 _winningTeam) public {
        require(msg.sender == owner, "Only owner can settle bets");
        matchResults[_matchId] = _winningTeam;

        for (uint256 i = 0; i < bets[_matchId].length; i++) {
            Bet storage bet = bets[_matchId][i];
            if (bet.selectedTeam == _winningTeam) {
                uint256 prize = bet.amount * 2; // Example payout calculation
                payable(bet.bettor).transfer(prize);
                emit BetSettled(bet.id, prize);
            }
        }
    }

    // Additional functions for managing matches and betting logic
}
