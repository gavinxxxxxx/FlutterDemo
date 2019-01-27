import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

main() => runApp(GankIO());

class GankIO extends StatelessWidget {
  @override
  build(BuildContext context) => MaterialApp(
        title: "声色",
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Text('Gank.io'),
          ),
          body: StaggeredView(),
        ),
      );
}

class StaggeredView extends StatefulWidget {
  @override
  createState() => StaggeredViewState();
}

class StaggeredViewState extends State<StaggeredView> {
  var _pageNo = 1;
  var _pool = <ImageModel>[];

  @override
  void initState() {
    super.initState();
    httpGet();
  }

  @override
  build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8.0),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      crossAxisCount: 4,
      itemCount: _pool.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      itemBuilder: (context, index) => buildTile(context, index),
    );
  }

  buildTile(BuildContext context, int index) {
    if (index == _pool.length - 1) {
      _pageNo++;
      httpGet();
    }

    Image image = new Image.network(_pool[index].url);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(info.image));

    return Card(
      margin: EdgeInsets.all(0.0),
      clipBehavior: Clip.hardEdge,

//      child: Image.network(_pool[index].url),

//      child: Image.network(_pool[index],),
//      child: AspectRatio(
//        aspectRatio: 8.0 / 12.0,
//        child: Image.network(
//          _pool[index],
//          fit: BoxFit.cover,
//        ),
//      ),

      child: FutureBuilder<ui.Image>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (_pool[index].width > 1 || snapshot.hasData) {
            if (_pool[index].width <= 1) {
              _pool[index].width = snapshot.data.width;
              _pool[index].height = snapshot.data.height;
            }
            return AspectRatio(
              aspectRatio: _pool[index].width / _pool[index].height,
              child: Image.network(_pool[index].url),
            );
          } else {
            return AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Text("loading..."),
              ),
            );
          }
        },
      ),
    );
  }

  void httpGet() async {
    print('httpGet - $_pageNo');
    try {
      //创建一个HttpClient
      HttpClient httpClient = HttpClient();
      //打开Http连接
      HttpClientRequest request = await httpClient
          .getUrl(Uri.parse('http://gank.io/api/data/福利/10/$_pageNo'));
      //等待连接服务器（会将请求信息发送给服务器）
      HttpClientResponse response = await request.close();
      //读取响应内容
      var text = await response.transform(utf8.decoder).join();
      var data = json.decode(text);
      List<ImageModel> urls = (data['results'] as List)
          .map((t) => ImageModel(t['url'].toString()))
          .toList();
      setState(() {
        _pool.addAll(urls);
      });
      //关闭client后，通过该client发起的所有请求都会中止。
      httpClient.close();
    } catch (e) {
      print(e);
    }
  }
}

class ImageModel {
  String url;
  int width;
  int height;

  ImageModel(this.url, {this.width = 1, this.height = 1});
}
