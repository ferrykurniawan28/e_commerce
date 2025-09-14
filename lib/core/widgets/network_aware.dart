part of 'widgets.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;
  final Widget loadingChild;

  const NetworkAwareWidget({
    super.key,
    required this.onlineChild,
    required this.offlineChild,
    this.loadingChild = const Center(child: CircularProgressIndicator()),
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: ReadContext(context).read<NetworkInfo>().connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingChild;
        }

        final isConnected = snapshot.data?.isNotEmpty == true &&
            !snapshot.data!.contains(ConnectivityResult.none);

        return isConnected ? onlineChild : offlineChild;
      },
    );
  }
}
