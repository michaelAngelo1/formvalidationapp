import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class User {
  final String username;
  final String password;
  final String status;

  User({
    required this.username,
    required this.password,
    required this.status,
  });
}

List<User> users = [
  User(
    username: 'atom',
    password: 'neutron',
    status: 'admin',
  ),
  User(
    username: 'uncle',
    password: 'rich',
    status: 'admin',
  ),
  User(
    username: 'user',
    password: 'CE Lab',
    status: 'user',
  ),
  User(
    username: 'anon',
    password: 'flakes',
    status: 'user',
  )
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: "Mike's Form Validation App"),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String? dispUsername;
  String? dispRole;
  late bool loginAuth;
  bool handleLogin(username, password) {
    loginAuth = false;
    // ignore: avoid_function_literals_in_foreach_calls
    users.forEach((user) => {
      if(user.username == username && user.password == password) {
        loginAuth = true,
        dispUsername = user.username,
        dispRole = user.status,
      }
    });
    if(!loginAuth) {
      dispUsername = "";
      dispRole = "";
    }
    notifyListeners();
    return loginAuth;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String loginFailed = "";

  @override
  void dispose() {
    context.read<MyAppState>().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Login Page",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600
                  )
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Enter username",
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                  onChanged: (value) => username = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Enter password",
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                  onChanged: (value) => password = value,
                ),
                const SizedBox(height: 18.0),
                ElevatedButton(
                  onPressed: () {
                    bool loginAuth = appState.handleLogin(username, password);
                    if(loginAuth) {
                      print("bener cok");
                      _formKey.currentState?.reset();
                    }
                    else {
                      print("salah cok");
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      Home(
                        isLogin: loginAuth, 
                        username: appState.dispUsername, 
                        role: appState.dispRole
                      )
                    ));
                  },
                  child: Text("Submit")
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final String? username;
  final String? role;
  final bool isLogin;
  const Home({
    super.key,
    required this.isLogin,
    required this.username,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              isLogin ? "Successfully logged in. Hi $username, your role is $role" : "Incorrect credentials. Login failed",
            )
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

            },
            child: Text("Back")
          )
        ],
      )
    );
  }
}
