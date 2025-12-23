import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LibraryHomePage(),
  ));
}

// --- CLASS _Book ---
class _Book {
  final String _name;
  bool _isBorrowed;

  // 2. Constructor
  _Book({required String name, bool isBorrowed = false})
      : _name = name,
        _isBorrowed = isBorrowed;

  // 3. Getters
  String get name => _name;
  bool get isBorrowed => _isBorrowed;

  // 4. Methods
  void muonSach() {
    _isBorrowed = true;
  }

  void traSach() {
    _isBorrowed = false;
  }
}
// ---------------------------------------------

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({super.key});

  @override
  State<LibraryHomePage> createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends State<LibraryHomePage> {
  int _selectedIndex = 0;
  int _currentUserIndex = 0;

  final List<String> users = ["Nguyễn Văn An", "Nguyễn Văn Be", "Lê Thị Chao"];

  // Kho sách
  final List<_Book> books = [
    _Book(name: "Cấu trúc dữ liệu và giải thuật", isBorrowed: true),
    _Book(name: "An toàn thông tin", isBorrowed: false),
    _Book(name: "Lập trình Android", isBorrowed: false),
    _Book(name: "Cấu trúc dữ liệu", isBorrowed: false),
    _Book(name: "Trí tuệ nhân tạo", isBorrowed: true),
    _Book(name: "Lịch sử văn minh", isBorrowed: false),
  ];

  // --- MƯỢN SÁCH TỪ KHO ---
  void _showBorrowDialog() {
    // Lọc ra danh sách sách CHƯA ĐƯỢC MƯỢN
    List<_Book> availableBooks = books.where((b) => !b.isBorrowed).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn sách để mượn"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: availableBooks.isEmpty
                ? const Center(child: Text("Hết sách trong kho!"))
                : ListView.builder(
              shrinkWrap: true,
              itemCount: availableBooks.length,
              itemBuilder: (context, index) {
                final book = availableBooks[index];
                return ListTile(
                  leading: const Icon(Icons.book, color: Colors.green),
                  title: Text(book.name),
                  trailing: const Icon(Icons.add_circle_outline, color: Colors.blue),
                  onTap: () {
                    setState(() {
                      book.muonSach();
                    });
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đã mượn: ${book.name}")),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  void _changeUser() {
    setState(() {
      _currentUserIndex = (_currentUserIndex + 1) % users.length;
    });
  }

  // Trang 1: Quản lý
  Widget _buildManagerScreen() {
    final borrowedBooks = books.where((b) => b.isBorrowed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nhân viên:", style: TextStyle(color: Colors.grey)),
                Text(users[_currentUserIndex], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(onPressed: _changeUser, child: const Text("Đổi người"))
          ],
        ),
        const Divider(height: 30, thickness: 1),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sách đang mượn (${borrowedBooks.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Expanded(
                child: borrowedBooks.isEmpty
                    ? const Center(child: Text("Chưa mượn cuốn nào", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  itemCount: borrowedBooks.length,
                  itemBuilder: (context, index) {
                    final book = borrowedBooks[index];
                    return Card(
                      color: Colors.blue[50],
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark, color: Colors.blue),
                        title: Text(book.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            // Nút trả sách nhanh (Sử dụng Method)
                            setState(() {
                              book.traSach();
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showBorrowDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Mượn sách mới", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // Trang 2: Kho sách
  Widget _buildAllBooksScreen() {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          leading: Icon(Icons.book, color: book.isBorrowed ? Colors.grey : Colors.green),
          title: Text(
            book.name,
            style: TextStyle(
              decoration: book.isBorrowed ? TextDecoration.lineThrough : null,
              color: book.isBorrowed ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            book.isBorrowed ? "Đã có người mượn" : "Có sẵn trong kho",
            style: TextStyle(color: book.isBorrowed ? Colors.red : Colors.green),
          ),
        );
      },
    );
  }

  // Trang 3: Nhân viên
  Widget _buildEmployeeScreen() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(child: ListTile(leading: CircleAvatar(child: Text("${index + 1}")), title: Text(users[index])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [_buildManagerScreen(), _buildAllBooksScreen(), _buildEmployeeScreen()];

    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý Thư viện"), centerTitle: true),
      body: Padding(padding: const EdgeInsets.all(16), child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.blue[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Mượn/Trả"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Kho Sách"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Nhân viên"),
        ],
      ),
    );
  }
}