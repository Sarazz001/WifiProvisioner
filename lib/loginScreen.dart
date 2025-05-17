import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homeScreen.dart';

//login screen widget allows users enter email and password
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _formKey = GlobalKey<FormState>();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	bool isSignUp = false;

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text("Home Automation"),
				backgroundColor: Colors.deepPurpleAccent,
				),
			body: Container(
				decoration: const BoxDecoration(
				  gradient: LinearGradient(
					colors: [Colors.greenAccent, Colors.blueAccent],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				 ),
				),
				padding: const EdgeInsets.all(20.0),
				child: Form( 
				key: _formKey,
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						const Icon(Icons.lock, size: 50, color: Colors.blue),
						const SizedBox( height: 16 ),
						if( !isSignUp ) ...[
							_buildEmailField(),
							const SizedBox(height: 16),
							_buildPasswordField(),
							const SizedBox(height: 16),
							ElevatedButton(
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.greenAccent.shade100,
									foregroundColor: Colors.blue,
									padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(15),
									),
								),
								onPressed: _login,
								child: Text(	'Login',
									style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
								),
							),
							const SizedBox(height: 22),
							TextButton(
								onPressed: () {
									setState(() {
										isSignUp = true;
									});
								},
								child: Text(
									"Sign Up",
									style: TextStyle(color: Colors.grey[300]),
									),
							),
						] else ...[
							_buildEmailField(),
							const SizedBox(height: 16),
							_buildPasswordField(),
							const SizedBox(height: 16),
							ElevatedButton(
								style: ElevatedButton.styleFrom(
										backgroundColor: Colors.greenAccent.shade100,
										foregroundColor: Colors.blue,
										padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
										shape: RoundedRectangleBorder(
											borderRadius: BorderRadius.circular( 15 ),
										)
								),
								onPressed: () {
									_signUp(
										_emailController.text.trim(),
										_passwordController.text.trim(),
									);
								},
								child: Text( 'Sign Up',
									style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),),
							),
							const SizedBox(height: 20),
							TextButton(
								onPressed: () {
								  setState( () {
									isSignUp = false;
								 });
								},
								child: Text(
									"Sign in",
									style: TextStyle( color: Colors.grey[800]),
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
				style: TextStyle(
					color: Colors.black,
					fontSize: 16,
				),

				decoration: InputDecoration(
					filled: true,
					fillColor: Colors.white,
					labelText: 'email',
					enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular( 15 ),
						borderSide: BorderSide( color: Colors.grey, width: 1.5 ),
					),
					focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(15),
						borderSide: BorderSide(color: Colors.greenAccent.shade200, width: 2.0),
					),
					errorBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(15),
						borderSide: BorderSide(color: Colors.red, width: 1.5),
					),
					focusedErrorBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(15),
						borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
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
			style: TextStyle(
				color: Colors.black,
				fontSize: 16,
			),
			decoration: InputDecoration(
				filled: true,
				fillColor: Colors.white,
				labelText: 'Password',
				enabledBorder: OutlineInputBorder(
					borderSide: BorderSide( color:  Colors.grey, width: 1.5),
					borderRadius: BorderRadius.circular(15),
				),
				focusedBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(15),
					borderSide: BorderSide(color: Colors.greenAccent.shade200, width: 2.0),
				),
				errorBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(15),
					borderSide: BorderSide(color: Colors.red, width: 1.5),
				),
				focusedErrorBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(15),
					borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
				),
			),
			obscureText: true,
			validator: (value) {
			  if( value == null || value.isEmpty) {
					return 'Please enter password';
			  } else if ( value.length < 7 )  {
					return 'Password length at least 6 characters';
			  }
			  return null;
			},
		);
	}

	Future<void> _signUp( String email, String password ) async {
		try{
		  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
			String message = "User credential added";
		  _showSuccessDialog( message );
		}
		on FirebaseAuthException catch (e) {
		  if ( e.code == 'weak-password') {
		    String message = "Weak password";
				_showErrorDialog( message );
		  }
		  else if ( e.code == 'email-already-in-use' ) {
				String message = "email already in use.";
				_showErrorDialog( message );
		  }
		}
		catch (e) {
			_showErrorDialog( "unexpected error occurred." );
		}
	}
	
	Future<void> _login() async {
		if (_formKey.currentState?.validate() ?? false ) {
		  final String email = _emailController.text.trim();
		  final String password = _passwordController.text.trim();
		  try {
				UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword( email:email, password: password );
				if (!mounted) {
					return;
				}
				Navigator.pushReplacementNamed( context, '/home' );
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
						_showErrorDialog('An unexpected error occurred');
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
