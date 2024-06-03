import 'package:flutter/material.dart';
import 'package:flutter_btl/API/api.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:flutter_btl/models/item.dart';

import '../../common/overlay_loading.dart';
import 'widgets/input_field.dart';

class AddItemPage extends StatefulWidget {
  final bool? isChange;
  final Item? item;
  const AddItemPage({
    super.key,
    this.isChange,
    this.item,
  });

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final controllerName = TextEditingController();
  final focusNodeName = FocusNode();
  final controllerEmail = TextEditingController();
  final focusNodeEmail = FocusNode();
  final controllerAddress = TextEditingController();
  final focusNodeAddress = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool _invalid = false;
  bool _isChangedForm = false;
  final _api = API();

  @override
  void initState() {
    if (widget.item != null) {
      controllerName.text = widget.item!.name;
      controllerEmail.text = widget.item!.email;
      controllerAddress.text = widget.item!.address;
    }
    super.initState();
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          content: const Text(
            'Cập nhật chưa được lưu. Bạn có chắc muốn hủy thay đổi ?',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Thoát',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'Tiếp tục',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return const Loading();
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: () async {
            bool shouldPop;
            if (_isChangedForm) {
              shouldPop = await _showBackDialog() ?? false;
              if (context.mounted && shouldPop) {
                context.pop();
              }
            } else {
              context.pop();
            }
          },
          child: const Icon(
            Icons.arrow_back,
            size: 22,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.isChange! ? 'Edit item' : 'Add item',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.white),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PopScope(
                  canPop: false,
                  onPopInvoked: (bool didPop) async {
                    if (didPop) {
                      return;
                    }
                    bool shouldPop;
                    if (_isChangedForm) {
                      shouldPop = await _showBackDialog() ?? false;
                      if (context.mounted && shouldPop) {
                        context.pop();
                      }
                    }
                  },
                  child: const SizedBox(),
                ),
                //--- ----
                Form(
                  key: formKey,
                  onChanged: () {
                    setState(() {
                      _invalid = formKey.currentState!.validate();
                      _isChangedForm = true;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      InputField(
                        controller: controllerName,
                        focusNode: focusNodeName,
                        hintText: 'Name',
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: controllerEmail,
                        focusNode: focusNodeEmail,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: controllerAddress,
                        focusNode: focusNodeAddress,
                        hintText: 'Address',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 3),

                //--- button completed ----
                const SizedBox(height: 30),
                Center(
                  child: FilledButton.tonal(
                    onPressed: () async {
                      if (_invalid) {
                        String formattedDateTime =
                            DateFormat('HH:mm (dd/MM/yyyy)')
                                .format(DateTime.now());
                        final Item newItem = Item(
                          id: widget.item != null ? widget.item!.id : -1,
                          name: controllerName.text,
                          email: controllerEmail.text,
                          address: controllerAddress.text,
                          createdAt: formattedDateTime,
                        );
                        if (widget.isChange!) {
                          overlayState.insert(overlayEntry);
                          await _api.updateItem(newItem).then((value) {
                            overlayEntry.remove();
                            context.pop();
                          });
                        } else {
                          overlayState.insert(overlayEntry);
                          await _api.addItem(newItem).then((value) {
                            overlayEntry.remove();
                            context.pop();
                          });
                        }
                      }
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width - 100, 45)),
                      backgroundColor: MaterialStatePropertyAll(
                        _invalid ? Colors.red : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      'Hoàn thành',
                      style: TextStyle(
                        fontSize: 16,
                        color: _invalid ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
