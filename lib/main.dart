import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
      theme: style.theme,
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => Text('첫페이지'),
      //   '/detail': (context) => Text('둘째페이지')
      // },
      // Navigator.pushNamed(context,'/detail') 이런식으로 이동시킬 수 있음
      home: const MyApp()));
}

var likeFontWeight = TextStyle(fontWeight: FontWeight.w600);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var list = [1, 2, 3];
  List<dynamic> data = [];
  int morePage = 1;

  getData() async {
    http.Response result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      dynamic result2 = jsonDecode(result.body);

      setState(() {
        data = result2;
      });
    }
  }

  getMoreData() async {
    http.Response result = await http.get(
        Uri.parse('https://codingapple1.github.io/app/more$morePage.json'));
    if (result.statusCode == 200) {
      dynamic result2 = jsonDecode(result.body);
      setState(() {
        if (data[data.length - 1]['id'] != result2['id']) {
          data.add(result2);
          morePage++;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Upload()));
            },
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          )
        ],
        shape: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      body: [Home(data: data, getMoreData: getMoreData), Text('샵페이지')][tab],

      // style: Theme.of(context)
      //     .textTheme
      //     .bodyMedium, // 가까운 theme 찾아서 스타일 적용할 수 있음

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: tab,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'shop')
        ],
      ),
      // Theme(data: ThemeData(), child: Container())
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.data, this.getMoreData});
  final data;
  final getMoreData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      // print(scroll.position.pixels);
      // print(scroll.position.userScrollDirection);
      // print(scroll.position.maxScrollExtent);
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        widget.getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 32, // 테두리까지 포함한 컨테이너 크기 설정
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, width: 1), // 1픽셀 테두리 설정
                          borderRadius: BorderRadius.circular(25), // 둥근 모서리 설정
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(25), // 이미지 둥글게 자르기
                          child: Image.network(
                            widget.data[i]['image'],
                            width: 25, // 이미지 크기 설정
                            height: 25, // 이미지 높이 설정
                            fit: BoxFit.cover, // 이미지가 잘리지 않고 꽉 차도록 설정
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // 이미지와 텍스트 사이 간격
                      Text(widget.data[i]['user'])
                    ],
                  ),
                ),
                Image.network(widget.data[i]['image']),
                Favorite(data: widget.data[i]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data[i]['date']),
                      Text(widget.data[i]['content'])
                    ],
                  ),
                )
              ],
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class Favorite extends StatefulWidget {
  const Favorite({super.key, this.data});
  final data;
  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: widget.data['liked']
              ? Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                )
              : Icon(Icons.favorite_border),
          onPressed: () {
            setState(() {
              if (widget.data['liked'] == false) {
                widget.data['liked'] = true;
                widget.data['likes'] += 1;
              } else {
                widget.data['liked'] = false;
                widget.data['likes'] -= 1;
              }
            });
          },
        ),
        Text(widget.data['likes'].toString())
      ],
    );
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이미지업로드화면'),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
    );
  }
}
