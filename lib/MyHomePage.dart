import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ebook/colors.dart' as myColors;
import 'package:project_ebook/home_screen.dart';
import 'package:project_ebook/my_tabs.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }): super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  late List popularBooks;
  late List books;
  late ScrollController _scrollController;
  late TabController _tabController;

  ReadData()async{
    await DefaultAssetBundle.of(context).loadString('json/popularBooks.json').then((s) {
      print(s); // This will print the loaded JSON data
      setState(() {
        popularBooks = json.decode(s);
      });
    });
    await DefaultAssetBundle.of(context).loadString('json/books.json').then((s) {
      print(s); // This will print the loaded JSON data
      setState(() {
        books = json.decode(s);
      });
    });
  }
  @override
  void initState(){
    super.initState();
      _tabController =  TabController(length: 3, vsync: this);
      _scrollController =ScrollController();
      ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: myColors.background,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ImageIcon(AssetImage('img/menu.png') ,  size: 24 , color: Colors.black,),
                    Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10,),
                        Icon(Icons.notifications),
                        SizedBox(width: 10,),
                        IconButton(
                            onPressed: () {
                              // Sign out the user
                              FirebaseAuth.instance.signOut().then((value) {
                                Navigator.pushReplacementNamed(context, '/');
                              }).catchError((error) {
                                print("Error signing out: $error");
                              });
                            },
                            icon: Icon(Icons.logout))
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text('Top Pick''s', style: TextStyle(fontSize: 30) ,),
                  )

                ],
              ),
             Container(
               margin:EdgeInsets.all(20),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage('img/logo.png'),
                      )
                    ),
                  ),

              Expanded(child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context , bool isScroll){
                  return[
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: myColors.sliverBackground,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50),

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TabBar(
                            indicatorPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.only(right: 10),
                            controller: _tabController,
                            isScrollable: true,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 7,
                                  offset: Offset(0,0),
                                )
                              ]
                            ),
                            tabs: [
                                my_tabs( color: myColors.menu1Color, text: 'New'),
                                my_tabs( color: myColors.menu3Color, text: 'Trending'),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                        itemCount : books.length,
                        itemBuilder: (_,i){
                      return Container(
                        margin: const EdgeInsets.only(left: 20 , right: 20, top: 10, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: myColors.tabVarViewColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0,0),
                                color: Colors.grey.withOpacity(0.2),
                              )
                            ]
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [

                                Container(

                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image:DecorationImage(
                                        image: AssetImage(books[i]['img']),
                                        fit: BoxFit.cover,
                                      )

                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 24 ,  color: myColors.starColor,),
                                        SizedBox(width: 5,),
                                        Text(books[i]['rating'],style: TextStyle(color: myColors.menu2Color),)

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(books[i]['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontFamily: 'Avenir'),),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  HomeScreen(ebook_name: books[i]['audio'],ebook_text:books[i]['text'] )),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.play_circle, // Replace with the icon you want
                                            color: Colors.purpleAccent , // Optionally, set the color of the icon
                                            size: 24, // Optionally, set the size of the icon
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(books[i]['text'],style: TextStyle(fontSize: 16, fontFamily: 'Avenir',color: myColors.subTitleText),)


                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
              }),

                    ListView.builder(
                        itemCount : popularBooks.length,
                        itemBuilder: (_,i){
                          return Container(
                            margin: const EdgeInsets.only(left: 20 , right: 20, top: 10, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: myColors.tabVarViewColor,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0,0),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ]
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [

                                    Container(

                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image:DecorationImage(
                                            image: AssetImage(popularBooks[i]['img']),
                                            fit: BoxFit.cover,
                                          )

                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star, size: 24 ,  color: myColors.starColor,),
                                            SizedBox(width: 5,),
                                            Text(popularBooks[i]['rating'],style: TextStyle(color: myColors.menu2Color),)

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(popularBooks[i]['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontFamily: 'Avenir'),),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  HomeScreen(ebook_name: popularBooks[i]['audio'],ebook_text: popularBooks[i]['audio'])),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.play_circle, // Replace with the icon you want
                                                color: Colors.purpleAccent , // Optionally, set the color of the icon
                                                size: 24, // Optionally, set the size of the icon
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(popularBooks[i]['text'],style: TextStyle(fontSize: 16, fontFamily: 'Avenir',color: myColors.subTitleText),)


                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                  ],
                ),
              ))
            ],
          )
        ),
      )
    );
  }
}