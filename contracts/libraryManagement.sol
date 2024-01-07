// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedLibrary {
    struct Book {
        uint256 id;
        string title;
        address currentHolder;
        bool isAvailable;
    }

    Book[] public books;
    mapping(uint256 => address) public bookRenters;

    function addBook(string memory _title) public {
        uint256 bookId = books.length;
        books.push(Book(bookId, _title, address(this), true));
    }

    function borrowBook(uint256 _bookId) public {
        Book storage book = books[_bookId];
        require(book.isAvailable, "Book is not available");

        book.currentHolder = msg.sender;
        book.isAvailable = false;
        bookRenters[_bookId] = msg.sender;
    }

    function returnBook(uint256 _bookId) public {
        require(bookRenters[_bookId] == msg.sender, "You are not the renter of this book");

        Book storage book = books[_bookId];
        book.currentHolder = address(this);
        book.isAvailable = true;
    }
}
