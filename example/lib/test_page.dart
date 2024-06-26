import 'package:flutter/material.dart';
import 'package:mop/mop.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller1 = TextEditingController(text: '5f72e3559a6a7900019b5baa');
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController(text: 'key1=value2&name=zhangsan');
  final TextEditingController _controller4 = TextEditingController(text: 'https://api.finclip.com/api/v1/mop/runtime/applet/-f-78d53c04618315e7--');

  int _selectedRadio = 0;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedRadio = value!;
    });
  }

  void _handleButtonPress() {
    // 在这里处理按钮点击事件
    String appId = _controller1.text.trim();
    String path = _controller2.text.trim();
    String query = _controller3.text.trim();

    int index = _selectedRadio;
    FCReLaunchMode mode = FCReLaunchMode.PARAMS_EXIST;
    if (index == 1) {
      mode = FCReLaunchMode.ONLY_PARAMS_DIFF;
    } else if (index == 2) {
      mode = FCReLaunchMode.ALWAYS;
    } else if (index == 3) {
      mode = FCReLaunchMode.NEVER;
    }

    Map<String, String>? startParams = {};
    if (path.length > 0) {
      startParams["path"] = path;
    }
    if (query.length > 0) {
      startParams["query"] = query;
    }
   
    RemoteAppletRequest request = RemoteAppletRequest(
      apiServer: 'https://api.finclip.com', 
      appletId: appId, 
      reLaunchMode: mode,
      startParams: startParams);
     Mop.instance.startApplet(request);
  }

  void _handleqrCodeButtonPress() {
    String qrcode = _controller4.text.trim();
    int index = _selectedRadio;
    FCReLaunchMode mode = FCReLaunchMode.PARAMS_EXIST;
    if (index == 1) {
      mode = FCReLaunchMode.ONLY_PARAMS_DIFF;
    } else if (index == 2) {
      mode = FCReLaunchMode.ALWAYS;
    } else if (index == 3) {
      mode = FCReLaunchMode.NEVER;
    }
    String qrCode = 'https://api.finclip.com/api/v1/mop/runtime/applet/-f-78d53c04618315e7--';
    QRCodeAppletRequest qrcodeRequest =  QRCodeAppletRequest(qrCode, reLaunchMode: mode);
    Mop.instance.qrcodeStartApplet(qrcodeRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试页面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildTextField(_controller1, '小程序id'),
            _buildTextField(_controller2, '输入path'),
            _buildTextField(_controller3, '输入query'),
            _buildTextField(_controller4, '二维码地址'),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                _buildRadioTile(0, 'ParamExist'),
                _buildRadioTile(1, 'OnlyParamDiff'),
                _buildRadioTile(2, 'Always'),
                _buildRadioTile(3, 'Never'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleButtonPress,
              child: Text('打开小程序'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleqrCodeButtonPress,
              child: Text('二维码打开小程序'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  Widget _buildRadioTile(int value, String title) {
    return GestureDetector(
      onTap: () => _handleRadioValueChange(value),
      child: Row(
        children: <Widget>[
          Radio(
            value: value,
            groupValue: _selectedRadio,
            onChanged: _handleRadioValueChange,
          ),
          Text(title),
        ],
      ),
    );
  }

}
