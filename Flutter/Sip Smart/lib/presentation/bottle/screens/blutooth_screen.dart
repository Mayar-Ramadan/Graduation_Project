import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';

class  BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BottleScreenState();
}

class _BottleScreenState extends State<BluetoothScreen> with SingleTickerProviderStateMixin {
  bool isSearching = false;
  bool isConnected = false;
  late AnimationController _controller;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startBluetoothProcess() async {
    final S = AppLocalizations.of(context)!;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted && 
        statuses[Permission.bluetoothConnect]!.isGranted) {
      
      setState(() {
        isSearching = true;
        scanResults.clear();
      });
      _controller.repeat(); 

      if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
        FlutterBluePlus.onScanResults.listen((results) {
          if (mounted) {
            setState(() {
              scanResults = results.where((r) => r.device.platformName.isNotEmpty).toList();
            });
          }
        });

        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
        await FlutterBluePlus.isScanning.where((scanning) => scanning == false).first;
        
        if (mounted) {
          setState(() {
            isSearching = false;
            _controller.stop();
          });
        }
      } else {
        _stopSearching();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.enableBluetoothError)),
        );
      }
    }
  }

  void _stopSearching() {
    setState(() {
      isSearching = false;
      _controller.stop();
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    final S = AppLocalizations.of(context)!;
    try {
      await FlutterBluePlus.stopScan();
      final dynamic flexibleDevice = device;
      
      await flexibleDevice.connect(
        autoConnect: false,
      ).timeout(const Duration(seconds: 20));

      setState(() {
        isConnected = true;
        isSearching = false;
        _controller.stop();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.connectedTo} ${device.platformName} ${S.successfully}!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.connectionFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          S.smartBottle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(
                  isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                  size: 80,
                  color: isSearching ? primaryColor.withOpacity(0.5) : primaryColor,
                ),
              ),
              const SizedBox(height: 30),

              Text(
                isConnected 
                    ? S.bottleConnected 
                    : (isSearching ? S.searchingDevices : S.noDeviceConnected),
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              Text(
                isSearching 
                    ? S.ensureBottleOn
                    : S.connectBottleDesc,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 30),

              if (isSearching && scanResults.isNotEmpty)
                _buildDeviceList(theme),

              const SizedBox(height: 20),

              if (isSearching)
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: Icon(Icons.sync, size: 45, color: primaryColor),
                )
              else if (!isConnected)
                _buildPairButton(theme)
              else
                _buildDisconnectButton(theme, S),

              const SizedBox(height: 40),
              
              if (!isConnected && !isSearching) _buildInstructionsBox(theme, S),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceList(ThemeData theme) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final device = scanResults[index].device;
          return ListTile(
            leading: Icon(Icons.bluetooth_searching, color: theme.primaryColor),
            title: Text(device.platformName, style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.link, size: 18, color: theme.primaryColor),
            onTap: () => _connectToDevice(device),
          );
        },
      ),
    );
  }

  Widget _buildPairButton(ThemeData theme) {
    final S = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      onPressed: startBluetoothProcess,
      icon: const Icon(Icons.bluetooth),
      label: Text(S.pairBottle),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildDisconnectButton(ThemeData theme, AppLocalizations S) {
    return OutlinedButton(
      onPressed: () => setState(() => isConnected = false),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(S.disconnect, style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildInstructionsBox(ThemeData theme, AppLocalizations S,) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
         border: Border.all(color: Color(0xFF1EBBFF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.pleaseMakeSure, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInstructionItem(theme, S.instructionBluetooth),
          _buildInstructionItem(theme, S.instructionPowerOn),
          _buildInstructionItem(theme, S.instructionProximity),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: theme.primaryColor),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}