// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: null,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        color: Colors.blue.withOpacity(0.2),
        surfaceTintColor: Colors.blue,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 6),
              child: GestureDetector(
                onTap: () {
                  context.go('/homePage');
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      size: 22,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: MediaQuery.of(context).size.width / 6),
              child: GestureDetector(
                onTap: () {
                  context.go('/profilePage');
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 22,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
