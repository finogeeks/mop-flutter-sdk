import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mop/mop.dart';

class NewFeaturesPage extends StatefulWidget {
  @override
  _NewFeaturesPageState createState() => _NewFeaturesPageState();
}

class _NewFeaturesPageState extends State<NewFeaturesPage> {
  final TextEditingController _searchController = TextEditingController(text: '绘图小程序');
  final TextEditingController _fileNameController = TextEditingController(text: 'test.txt');
  final TextEditingController _finFileController = TextEditingController(text: 'finfile://tmp_test.txt');

  String _resultText = '';
  List<Map<String, dynamic>> _usedApplets = [];
  List<Map<String, dynamic>> _searchResults = [];

  void _showResult(String result) {
    setState(() {
      _resultText = result;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新功能测试'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. 小程序预加载'),
          ElevatedButton(
            onPressed: () async {
              try {
                Map<String, dynamic> result = await Mop.instance.downloadApplets(
                  ['5f72e3559a6a7900019b5baa', '5facb3a52dcbff00017469bd'],
                  'https://api.finclip.com',
                );
                if (result['success'] == true) {
                  final data = result['data'] as Map?;
                  final list = data?['list'] as List?;
                  if (list != null && list.isNotEmpty) {
                    _showResult('预加载结果：\n${list.map((e) => e.toString()).join('\n')}');
                  } else {
                    _showResult('预加载完成，但没有返回数据');
                  }
                } else {
                  _showResult('预加载失败：${result['retMsg']}');
                }
              } catch (e) {
                _showResult('预加载失败：$e');
              }
            },
            child: Text('批量预加载小程序'),
          ),

          Divider(),
          _buildSectionTitle('2. 搜索小程序'),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '搜索关键词',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (_searchController.text.isEmpty) {
                _showSnackBar('请输入搜索关键词');
                return;
              }
              try {
                Map<String, dynamic> result = await Mop.instance.searchApplets(
                  _searchController.text,
                  'https://api.finclip.com',
                );
                if (result['success'] == true) {
                  final data = result['data'] as Map?;
                  if (data != null) {
                    final list = data['list'] as List?;
                    setState(() {
                      if (list != null && list.isNotEmpty) {
                        _searchResults = list.map((item) {
                          if (item is Map) {
                            return Map<String, dynamic>.from(item);
                          }
                          return <String, dynamic>{};
                        }).toList();
                      } else {
                        _searchResults = [];
                      }
                    });
                    _showResult('搜索到 ${data['total'] ?? 0} 个小程序'"\n"'数据格式结构示例:\n' + const JsonEncoder.withIndent('  ').convert(_searchResults[0]));
                  } else {
                    setState(() {
                      _searchResults = [];
                    });
                    _showResult('搜索成功但没有数据');
                  }
                } else {
                  _showResult('搜索失败：${result['retMsg']}');
                }
              } catch (e) {
                _showResult('搜索失败：$e');
              }
            },
            child: Text('搜索'),
          ),
          if (_searchResults.isNotEmpty)
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final applet = _searchResults[index];
                  return ListTile(
                    title: Text(applet['appName'] ?? ''),
                    leading: _buildAppletLogo(applet['logo']),
                    onTap: () {
                      _showSnackBar('点击了：${applet['appName']}');
                    },
                  );
                },
              ),
            ),

          Divider(),
          _buildSectionTitle('3. 最近使用的小程序'),
          ElevatedButton(
            onPressed: () async {
              try {
                Map<String, dynamic> result = await Mop.instance.getUsedApplets();
                if (result['success'] == true) {
                  final data = result['data'] as Map?;
                  final list = data?['list'] as List?;
                  if (list != null) {
                    setState(() {
                      _usedApplets = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
                    });
                    _showResult('获取到 ${list.length} 个最近使用的小程序'"\n"'数据格式结构示例:\n' + const JsonEncoder.withIndent('  ').convert(list[0]));
                  } else {
                    _showResult('没有最近使用的小程序');
                  }
                } else {
                  _showResult('获取失败：${result['retMsg']}');
                }
              } catch (e) {
                _showResult('获取失败：$e');
              }
            },
            child: Text('获取最近使用的小程序'),
          ),
          if (_usedApplets.isNotEmpty)
            Container(
              height: 150,
              child: ListView.builder(
                itemCount: _usedApplets.length,
                itemBuilder: (context, index) {
                  final applet = _usedApplets[index];
                  return ListTile(
                    title: Text(applet['name'] ?? applet['appTitle'] ?? ''),
                    subtitle: Text('ID: ${applet['appId'] ?? ''}'),
                  );
                },
              ),
            ),

          Divider(),
          _buildSectionTitle('4. 文件路径转换'),
          TextField(
            controller: _finFileController,
            decoration: InputDecoration(
              labelText: 'finfile路径',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> result = await Mop.instance.getFinFileAbsolutePath(
                        _finFileController.text,
                        needFileExist: false,
                      );
                      if (result['success'] == true) {
                        final data = result['data'] as Map?;
                        final path = data?['path'];
                        _showResult('绝对路径：\n$path');
                      } else {
                        _showResult('转换失败：${result['retMsg']}');
                      }
                    } catch (e) {
                      _showResult('转换失败：$e');
                    }
                  },
                  child: Text('转换为绝对路径'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _fileNameController,
            decoration: InputDecoration(
              labelText: '文件名',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> result = await Mop.instance.generateFinFilePath(
                        _fileNameController.text,
                        FinFilePathType.TMP,
                      );
                      if (result['success'] == true) {
                        final data = result['data'] as Map?;
                        final path = data?['path'];
                        _showResult('生成的TMP路径：\n$path');
                      } else {
                        _showResult('生成失败：${result['retMsg']}');
                      }
                    } catch (e) {
                      _showResult('生成失败：$e');
                    }
                  },
                  child: Text('生成TMP路径'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> result = await Mop.instance.generateFinFilePath(
                        _fileNameController.text,
                        FinFilePathType.USR,
                      );
                      if (result['success'] == true) {
                        final data = result['data'] as Map?;
                        final path = data?['path'];
                        _showResult('生成的USR路径：\n$path');
                      } else {
                        _showResult('生成失败：${result['retMsg']}');
                      }
                    } catch (e) {
                      _showResult('生成失败：$e');
                    }
                  },
                  child: Text('生成USR路径'),
                ),
              ),
            ],
          ),

          Divider(),
          _buildSectionTitle('5. 小程序收藏'),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Map<String, dynamic> result = await Mop.instance.getFavoriteApplets(
                        'https://api.finclip.com',
                      );
                      if (result['success'] == true) {
                        final data = result['data'] as Map?;
                        if (data != null && data['data'] != null) {
                          final innerData = data['data'] as Map;
                          final total = innerData['total'] ?? 0;
                          final list = innerData['list'] as List? ?? [];

                        /*  String listInfo = '';
                          for (var item in list) {
                            if (item is Map) {
                              listInfo += '\n  - ${item['name'] ?? '未知'} (${item['appId'] ?? ''})';
                            }
                          }*/

                          // _showResult('收藏列表：\n总数：$total$listInfo');
                          _showResult('收藏列表：\n总数：$total'"\n"'数据格式结构示例:\n' + const JsonEncoder.withIndent('  ').convert(list[0]));
                        } else {
                          _showResult('获取收藏列表成功，但没有数据');
                        }
                      } else {
                        _showResult('获取收藏列表失败：${result['retMsg'] ?? '未知错误'}');
                      }
                    } catch (e) {
                      _showResult('获取收藏列表失败：$e');
                    }
                  },
                  child: Text('获取收藏列表'),
                ),
              ),
            ],
          ),

          Divider(),
          _buildSectionTitle('6. 移动小程序到前台（仅Android）'),
          ElevatedButton(
            onPressed: () async {
              try {
                  Mop.instance.moveCurrentAppletToFront();
                _showResult('已移动到前台');
              } catch (e) {
                _showResult('移动失败：$e');
              }
            },
            child: Text('移动到前台'),
          ),

          Divider(),
          _buildSectionTitle('执行结果'),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _resultText.isEmpty ? '暂无结果' : _resultText,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildAppletLogo(String? logoUrl) {
    if (logoUrl == null || logoUrl.isEmpty) {
      return Icon(Icons.apps);
    }

    // 检查是否是完整的URL
    if (!logoUrl.startsWith('http://') && !logoUrl.startsWith('https://')) {
      // 如果不是完整URL，添加基础URL
      logoUrl = 'https://api.finclip.com$logoUrl';
    }

    return Image.network(
      logoUrl,
      width: 40,
      height: 40,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.apps);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
    );
  }
}