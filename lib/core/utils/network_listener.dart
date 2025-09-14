part of 'utils.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;

  const NetworkListener({Key? key, required this.child}) : super(key: key);

  @override
  _NetworkListenerState createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _listenToConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    final isConnected = await context.read<NetworkInfo>().isConnected;
    setState(() {
      _isConnected = isConnected;
    });
  }

  void _listenToConnectionChanges() {
    context.read<NetworkInfo>().connectivityStream.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      if (_isConnected != isConnected) {
        setState(() {
          _isConnected = isConnected;
        });

        if (!isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are offline'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Back online'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
