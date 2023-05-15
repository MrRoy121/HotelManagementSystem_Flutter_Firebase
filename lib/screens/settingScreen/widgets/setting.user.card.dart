import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Color? cardColor;
  final double? cardRadius;
  final Color? backgroundMotifColor;
  final VoidCallback? onTap;
  final bool url;
  final String? userProfileUrl;
  final String useremail;
  final String? userName;

  UserCard({
    required this.cardColor,
    this.cardRadius = 30,
    required this.userName,
    required this.url,
    this.backgroundMotifColor = Colors.white,
    required this.onTap,
    this.userProfileUrl,
    required this.useremail,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: mediaQueryHeight / 6,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                BorderRadius.circular(double.parse(cardRadius!.toString())),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: backgroundMotifColor!.withOpacity(.1),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 400,
                  backgroundColor: backgroundMotifColor!.withOpacity(.05),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff7c94b6),
                              image: url
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        userProfileUrl!,
                                      ),
                                      fit: BoxFit.contain,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/def_usr.png",
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                useremail!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
