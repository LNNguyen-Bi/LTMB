import "package:flutter/material.dart";

class MyButton_2 extends StatelessWidget {
  const MyButton_2({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban

    // Man hinh

    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tieu de
        title: Text("App 02"),

        // Mau nen
        backgroundColor: Colors.yellow,

        // Do nang/ do bong cua AppBar
        elevation: 4,

        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },

            icon: Icon(Icons.search),
          ),

          IconButton(
            onPressed: () {
              print("b2");
            },

            icon: Icon(Icons.abc),
          ),

          IconButton(
            onPressed: () {
              print("b3");
            },

            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),

            // ElevatedButton là một button nổi với hiệu ứng đổ bóng,

            // thường được sử dụng cho các hành động chính trong ứng dụng.
            ElevatedButton(
              onPressed: () {
                print("ElevatedButton");
              },

              child: Text("ElevatedButton", style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                //màu nền
                backgroundColor: Colors.brown,
                //màu các nội dung bên trong
                foregroundColor: Colors.white,
                //dạng hình
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),),
                  //padding
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                  ),
                  //elevate
                  elevation: 15,
                )
              ),

            SizedBox(height: 20),

            // TextButton là một button phẳng,

            // , không có đổ bóng,

            // thường dùng cho các hành động thứ yếu

            // hoặc trong các thành phần như Dialog, Card.

            OutlinedButton(
              onPressed: () {
                print("OutlinedButton");
              },

              child: Text("OutlinedButton", style: TextStyle(fontSize: 24)),
              style: OutlinedButton.styleFrom(
                //màu nền
                backgroundColor: Colors.green,
                //màu các nội dung bên trong
                foregroundColor: Colors.white,

                //padding
                padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                ),
                //elevate
                elevation: 15,
              )
            ),


            SizedBox(height: 50,),
            //InkWell
            InkWell(
              onTap: (){
                print("InkWell được nhấn ");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: Text("Button tùy chỉnh với InkWell"),
              ),
            )

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },

        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}
