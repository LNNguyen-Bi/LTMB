import "dart:ui";

import "package:flutter/material.dart";

class Mytextfield extends StatelessWidget{
  const Mytextfield({super.key});

  @override
  Widget build(BuildContext context) {
    // trả về Scaffold - widget cung cấp bố cục Material Desigh
    // Màn hình
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        title: Text("App 02"),
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              // TextField cho phép người dùng nhập văn bản thông qua phím
              //đây là thành phần thiết yếu hầu hết các ứng dụng từ biểu mẫu đăng nhập và tìm kiếm, đến nhập liệu trong các ứng dụng phức tạp
              TextField(
                decoration: InputDecoration(
                  labelText: "Họ và Tên",
                  hintText: "Nhập họ và tên của bạn",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Exmaple@gmail.com",
                  helperText: "Nhập vào email cá nhân",
                  prefixIcon: Icon(Icons.email),
                  suffixIcon: Icon(Icons.clear),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  filled: true,
                  fillColor: Colors.greenAccent
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "SĐT",
                  hintText: "Nhập vào SĐT của bạn",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "Ngày sinh",
                  hintText: "Nhập vào ngày sinh của bạn",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),

              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                obscureText: true,
                obscuringCharacter: "*",
              ),

              SizedBox(height: 30),
              TextField(
                onChanged: (value){
                  print("đang nhập: $value");
                },
                onSubmitted: (value){
                  print("đã hoàn thành nội dung: $value");
                },

                decoration: InputDecoration(
                  labelText: "câu hỏi bí mật",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),

            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){print("pressed");},
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Trang chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.percent), label: "Cá nhân"),
      ]),
    );
  }
}