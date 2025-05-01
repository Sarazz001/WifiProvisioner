import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
	
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _formkey = GlobalKey<FormState>();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	bool isSignUp = false;

	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Home Automationer"),
				),
			body: Container(
				decoration: BoxDecoration(
				  gradient: LinearGradient(
					colors: [Colors.greenAccent, Colors.blueAccent],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				),
				padding: EdgeInsets.all(20.0),
				child: Form( 
				key: _formkey,
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Icon(Icons.lock, size: 100, color: Colors.blue),
						SizedBox(height: 16),
						if( !isSignUp ) ...[
							_buildEmailField(),
							SizedBox(height: 16),
							_buildPasswordField(),
							SizedBox(height: 16),
							ElevatedButton(
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.purple[100],
									padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(25),
									),
								),
								onPressed: _login,
								child: Text('login'),
								),
							SizedBox(height: 22),
							TextButton(
								onPressed: () {
									setState(() {
										isSignUp = true;
									});
								},
								child: Text(
									"Sign Up",
									style: TextStyle(color: Colors.indigo.withOpacity(0.8)),
									),
								),
						] else ...[
							_buildEmailField(),
							SizedBox(height: 16),
							_buildPasswordField(),
							SizedBox(height: 16),
							ElevatedButton(
							  style: ElevatedButton.styleFrom(
								backgroundColor: Colors.purple[100],
								padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(25),
								),
							  ),
							  onPressed: () {
								_signUp(
								  _emailController.text.trim(),
								  _passwordController.text.trim(),
								);
							},
							child: Text('Sign Up'),
							),
							SizedBox(height: 20),
							TextButton(
								onPressed: () {
								  setState( () {
									isSignUp = false;
								 });
								},
								child: Text(
									"Sign in",
									style: TextStyle( color: Colors.indigo.withOpacity(0.8)),
								),
							),
						],
					     ],							  
					),	
				),
			   ),
			);

		}

	Widget _buildEmailField() {
		return TextFormField(
				controller: _emailController,
				decoration: InputDecoration(
					filled: true,
					fillColor: Colors.white.withOpacity(0.8),		
					labelText: 'Email',
					border: OutlineInputBorder(
					  borderRadius: BorderRadius.circular(25)
					),
				),
				keyboardType: TextInputType.emailAddress,
				validator: (value) {
					if( value == null || value.isEmpty) {
						return "Please enter email id";
					}
					return null;
				}, 	
			);
	}

	Widget _buildPasswordField() {
		return TextFormField(
			controller: _passwordController,
			decoration: InputDecoration(
				filled: true,
				fillColor: Colors.white.withOpacity(0.8),
				labelText: 'Password',
				border: OutlineInputBorder(
				  borderRadius: BorderRadius.circular(25)
				),
			),
			obscureText: true,
			validator: (value) {
			  if( value == null || value.isEmpty) {
				return 'Please enter password';
			  } else if ( value.length < 7 )  {
				return 'Password length atleast 6 characters';
			  }
			  return null;
			},
		);
	}

	Future<void> _signUp( String email, String password ) async {
		try{
		  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
		  print('user credential added');
		}
		on FirebaseAuthException catch (e) {
		  if ( e.code == 'weak-password') {
		    print('provided password is weak');
		  }
		  else if ( e.code == 'email-already-in-use' ) {
		    print('An Account is already in use');
		  }
		}
		catch (e) {
		  print(e);
		}
	}
	
	Future<void> _login() async {
		if (_formkey.currentState?.validate() ?? false ) {
		  final String email = _emailController.text.trim();
		  final String password = _passwordController.text.trim();
		  
		  try {
			UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword( email:email, password: password );
			
			Navigator.pushReplacement(
				context, 
				MaterialPageRoute( builder: (context) => HomeScreen()),
			);
		  } on FirebaseAuthException catch (e) {
			String message = 'Login failed';
			if( e.code == 'user-not-found' ) {
				message = 'No User found for that email';
			} else if ( e.code == 'wrong-password' ) {
				message = 'Incorrect password';
			}
			_showErrorDialog( message );
		    }
		    catch (e) {
			_showErrorDialog('An unexpected error occured');
		    } 	
		}	 	 
	}

	void _showErrorDialog( String message ) {
		showDialog(
			context: context,
			builder: (BuildContext context){
				return AlertDialog(
					title: Text('Error'),
					content: Text(message),
					actions: <Widget>[
						TextButton(
							onPressed: (){
								Navigator.of(context).pop();
							},
						       child: Text('OK'),
						),
					],
				);
			},
		);
	}

	void _showSuccessDialog( String message ) {
		showDialog( 
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Login Success'),
					content: Text( message ),
					actions: <Widget>[
						TextButton(
							onPressed: (){
								Navigator.of(context).pop();
							},
							child: Text('OK'),
						),
					],
				);
			},
		);
	}
	
}
