import "package:flutter/material.dart";

class Mygestures extends StatelessWidget{
  const Mygestures({super.key});

  @override
  Widget build(BuildContext context) {
    // trả về Scaffold - widget cung cấp bố cục Material Desigh
    // Màn hình
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        title: Text("App 02"),
      ),


      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            //GesturesDetector - bắt được các sự kiện
            GestureDetector(
              onTap: (){
                print("nội dung được tap");
              },
              onDoubleTap: (){
                print("Nội dung được tap 2 cái");
              },
              onPanUpdate: (details){
                print('kéo - di chuyển: ${details.delta}');
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.brown,
                child: Center(child: Text("chạm vào tôi!")),
              ),
            )
          ],
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