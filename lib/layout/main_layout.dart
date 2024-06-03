import 'package:flutter/material.dart';
import 'package:flutter_btl/pages/addItemPage/add_item_page.dart';
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
    // print(GoRouterState.of(context).uri.toString());
    return Scaffold(
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const AddItemPage(isChange: false, item: null)));
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(3),
        height: 50,
        color: Colors.blue.withOpacity(0.01),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      size: 22,
                      color: GoRouterState.of(context).uri.toString() ==
                              '/homePage'
                          ? Colors.blue
                          : Colors.grey.shade600,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        color: GoRouterState.of(context).uri.toString() ==
                                '/homePage'
                            ? Colors.blue
                            : Colors.grey.shade600,
                      ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 22,
                      color: GoRouterState.of(context).uri.toString() ==
                              '/profilePage'
                          ? Colors.blue
                          : Colors.grey.shade600,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 12,
                        color: GoRouterState.of(context).uri.toString() ==
                                '/profilePage'
                            ? Colors.blue
                            : Colors.grey.shade600,
                      ),
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
