import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finager/providers/transaction_form_provider.dart';
import 'package:finager/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finager/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class AccountSection extends ConsumerStatefulWidget {
  const AccountSection({super.key});

  @override
  ConsumerState<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends ConsumerState<AccountSection> {
  String? _imagePath;
  String? _displayName;

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
    );
    if (source != null) {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        final authService = AuthService();
        final imagePath = await authService.updateProfileImage(imageFile);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('profileImageUrl', imagePath);
        setState(() => _imagePath = imagePath);
      }
    }
  }

  void _showImagePreview(BuildContext context, ImageProvider image) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: InteractiveViewer(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: image, fit: BoxFit.contain),
                ),
                height: 300,
                width: 300,
              ),
            ),
          ),
    );
  }

  Future<void> _editDisplayName(
    BuildContext context,
    String currentName,
  ) async {
    final appLocal = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    final schemeColor = Theme.of(context).colorScheme.tertiary;

    final result = await showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(appLocal.editDisplayName),
            content: TextField(
              controller: controller,
              cursorColor: Colors.indigoAccent,
              selectionControls: materialTextSelectionControls,
              decoration: InputDecoration(
                labelText: appLocal.displayName,
                labelStyle: const TextStyle(color: Colors.indigoAccent),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  appLocal.cancel,
                  style: TextStyle(color: schemeColor),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.withAlpha(220),
                ),
                child: Text(
                  appLocal.saveChanges,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final authService = AuthService();
      await authService.updateDisplayName(result.trim());

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('displayName', result.trim());

      setState(() => _displayName = result.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoFuture = ref.read(preferencesServiceProvider).getUserInfo();
    final appLocal = AppLocalizations.of(context)!;

    return FutureBuilder<Map<String, dynamic>>(
      future: userInfoFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userInfo = snapshot.data!;
        final profileImageUrl = _imagePath ?? userInfo['profileImageUrl'];

        ImageProvider? imageProvider;
        if (_imagePath != null && !_imagePath!.startsWith('http')) {
          imageProvider = FileImage(File(_imagePath!));
        } else if (profileImageUrl != null &&
            profileImageUrl.toString().startsWith('http')) {
          imageProvider = CachedNetworkImageProvider(profileImageUrl);
        }

        final displayName =
            _displayName ??
            (userInfo['displayName']?.toString().trim().isNotEmpty == true
                ? userInfo['displayName']
                : 'Unknown');

        return Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () => _pickImage(context),
                onLongPress: () {
                  if (imageProvider != null) {
                    _showImagePreview(context, imageProvider);
                  }
                },
                child: ClipOval(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child:
                        imageProvider != null
                            ? CachedNetworkImage(
                              imageUrl: profileImageUrl ?? '',
                              imageBuilder:
                                  (context, imageProvider) => CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 25,
                                  ),
                              placeholder:
                                  (context, url) => Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 25,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => const CircleAvatar(
                                    child: Icon(Icons.error),
                                  ),
                            )
                            : const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => _editDisplayName(context, displayName),
                child: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text("@${userInfo['username'] ?? 'username'}"),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                appLocal.logout,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text(
                          appLocal.logout,
                          style: const TextStyle(color: Colors.red),
                        ),
                        content: Text(appLocal.logoutConfirmation),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              appLocal.cancel,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              appLocal.confirm,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                }
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
