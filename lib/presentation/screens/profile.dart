import 'package:firfir_tera/bloc/auth/auth_bloc.dart';
import 'package:firfir_tera/bloc/auth/auth_even.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/profile_pic/profile_2.jpg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aregawi Fikre',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'aregawifikre@gmail.com',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.goNamed("/edit_profile");
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    minimumSize: MaterialStateProperty.all(const Size(90, 40)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)))),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LoggedOut());
                  context.goNamed("/login");
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(90, 40)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)))),
                child:
                    const Text('Log Out', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
