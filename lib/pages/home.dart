import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/check_out.dart';
import 'package:flower_app/pages/details_screen.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/pages/profile.dart';
import 'package:flower_app/provider/cart_provider.dart';
import 'package:flower_app/provider/google_sign_in_provider.dart';
import 'package:flower_app/shared/appbar.dart';
import 'package:flower_app/shared/constants.dart';
import 'package:flower_app/shared/item.dart';
import 'package:flower_app/shared/snackbar.dart';
import 'package:flower_app/shared/user_img_from_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    ///////////////////// Provider ////////////
    final googleProvider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    final cartInstance = Provider.of<Cart>(context);
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(user.photoURL ??
                            "https://img.freepik.com/free-vector/gradient-network-connection-background_23-2148881320.jpg"),
                        fit: BoxFit.cover),
                  ),
                  accountName: user.displayName != null
                      ? Text(
                          "${user.displayName}",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(''),
                  accountEmail: Text(
                    "${user.email}",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  currentAccountPictureSize: const Size.square(85),
                  currentAccountPicture: ImgUser(),

                  // googleProvider.googleSignIn != null
                  //     // (user.uid.isEmpty)
                  //     // (registeredProvider.url == null)
                  //     ? CircleAvatar(
                  //         backgroundColor: Color.fromARGB(255, 225, 225, 225),
                  //         radius: 70,
                  //         // backgroundImage: AssetImage("assets/img/avatar.png"),
                  //         backgroundImage: AssetImage("assets/img/avatar.png"),
                  //       )
                  //     :

                  // ImgUser(),
                ),
                ListTile(
                    title: const Text(
                      "Home",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    leading:
                        const Icon(Icons.home, size: 40, color: appBarGreen),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    }),
                ListTile(
                    title: const Text(
                      "My products",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    leading: const Icon(
                      Icons.add_shopping_cart,
                      size: 40,
                      color: appBarGreen,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckOut(),
                        ),
                      );
                    }),
                ListTile(
                    title: const Text(
                      "About",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    leading: const Icon(
                      Icons.help_center,
                      size: 40,
                      color: appBarGreen,
                    ),
                    onTap: () {}),
                ListTile(
                    title: const Text(
                      "My Profile",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    leading: const Icon(
                      Icons.personal_injury_outlined,
                      size: 40,
                      color: appBarGreen,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    }),
                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  leading: const Icon(
                    Icons.exit_to_app,
                    size: 40,
                    color: appBarGreen,
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    googleProvider.googleSignIn.signOut();
                    debugPrint('logout');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                    showSnackBar(context, "Goodbye", 3);
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text(
                "Developed by ~HESHAM^MOHAMED~ ©2023",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBarGreen,
        title: const Text("Home"),
        centerTitle: true,
        actions: const [ProductAndPrice()],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
              decoration: BoxDecoration(color: Colors.white70),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 3.5,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Positioned(
                          top: -25,
                          bottom: -15,
                          left: 0,
                          right: 0,
                          child: GridTile(
                            footer: GridTileBar(
// backgroundColor: Color.fromARGB(66, 73, 127, 110),
                              trailing: IconButton(
                                color: const Color.fromARGB(255, 62, 94, 70),
                                onPressed: () {
                                  cartInstance.add(items[index]);
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                              ),

                              leading: Text(
                                "\$${items[index].price}",
                                style: const TextStyle(fontSize: 16),
                              ),

                              title: const Text(
                                "",
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Details(
                                      product: items[index],
                                    ),
                                  ),
                                );
                              },
// use ClipRRect & Positioned
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 5,
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.asset(items[index].imgPath),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: appBarGreen),
            child: SizedBox(
              height: 40,
              child: Center(
                  child: Text(
                'FLOWER STORE ©',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
