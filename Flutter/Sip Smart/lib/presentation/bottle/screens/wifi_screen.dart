import 'package:flutter/material.dart';
import 'package:gradution_project_smart_sip/core/services/wifi_provisioning_service.dart';
import 'package:gradution_project_smart_sip/core/services/wifi_scan_service.dart';
import 'package:gradution_project_smart_sip/l10n/app_localizations.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/widgets/hidden_network_button.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/widgets/wifi_dialogs.dart';
import 'package:gradution_project_smart_sip/presentation/bottle/widgets/wifi_network_tile.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen>
    with SingleTickerProviderStateMixin {
  bool isSearching = false;
  bool isConnected = false;
  bool _isScanningInProgress = false;
  String? errorMessage;

  late AnimationController _controller;

  final WifiScanService wifiScanService = WifiScanService();
  final WifiProvisioningService wifiProvisioningService =
      WifiProvisioningService();

  List<WiFiAccessPoint> networks = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        scanWifiNetworks();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> scanWifiNetworks() async {
if (_isScanningInProgress) return; 
  _isScanningInProgress = true;

    final s = AppLocalizations.of(context)!;
    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    _controller.repeat();

    try {
      final result = await wifiScanService.scanNetworks();

      if (!mounted) return;

      setState(() {
        networks = result;
        isSearching = false;
      });

      _controller.stop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSearching = false;
        errorMessage = s.cannotGetWifiResults;
      });

      _controller.stop();
    } finally {
    _isScanningInProgress = false;
  }
  }

  Future<void> sendCredentialsToEsp({
    required String ssid,
    required String password,
  }) async {
    final s = AppLocalizations.of(context)!;

    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    _controller.repeat();

    try {
      final result = await wifiProvisioningService.sendWifiCredentials(
        ssid: ssid,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        isSearching = false;
        isConnected = result.success;
        errorMessage = result.success
            ? null
            : (result.message ?? s.failedSendWifiCredentials);
      });

      _controller.stop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSearching = false;
        isConnected = false;
        errorMessage = s.cannotReachEsp;
      });

      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
        title: Text(
          s.wifiTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: isSearching ? null : scanWifiNetworks,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: primary.withOpacity(0.15),
                child: Icon(
                  isConnected ? Icons.wifi : Icons.wifi_find,
                  size: 80,
                  color: isSearching ? primary.withOpacity(0.5) : primary,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                isConnected
                    ? s.networkConnected
                    : (isSearching
                        ? s.searchingNetworks
                        : s.chooseWifiNetwork),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                isSearching ? s.searchingDescription : s.selectWifiOrHidden,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 30),

              if (isSearching)
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  child: Icon(Icons.sync, size: 45, color: primary),
                ),

              if (!isSearching && errorMessage != null) ...[
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              if (!isSearching && !isConnected) ...[
                const SizedBox(height: 20),

                if (networks.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: networks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final network = networks[index];

                      return WifiNetworkTile(
                        ssid: network.ssid,
                        level: network.level,
                        onTap: () {
                          WifiDialogs.showPasswordDialog(
                            context: context,
                            ssid: network.ssid,
                            onConnect: (password) {
                              sendCredentialsToEsp(
                                ssid: network.ssid,
                                password: password,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 20),

                HiddenNetworkButton(
                  onPressed: () {
                    WifiDialogs.showHiddenNetworkDialog(
                      context: context,
                      onConnect: (ssid, password) {
                        sendCredentialsToEsp(
                          ssid: ssid,
                          password: password,
                        );
                      },
                    );
                  },
                ),

                if (networks.isEmpty && errorMessage == null) ...[
                  const SizedBox(height: 20),
                  Text(
                    s.noNetworksFound,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],

              if (isConnected) ...[
                const SizedBox(height: 30),
                _buildDisconnectButton(s.disconnect),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisconnectButton(String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          isConnected = false;
          errorMessage = null;
        });
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}