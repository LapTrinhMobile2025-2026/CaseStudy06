# Hệ thống quản lý thư viện

**Class: Book(name, isBorrowed)**

**Logic:**

_buildManagerScreen: Trang quản lý

    Sách chưa mượn: availableBooks = List<Book> isBorrowed==false
    Sách đang mượn: borrowedBooks = List<Book> isBorrowed==true

_buildAllBooksScreen: Trang DS sách

    Hiện toàn bộ sách

_buildEmployeeScreen: Trang Nhân viên
    
    Hiện toàn bộ nhân viên

    (Mượn sách mới) -> availableBooks-> (+) -> isBorrowed=true

