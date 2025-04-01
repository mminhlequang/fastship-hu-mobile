import 'package:flutter/material.dart';

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildAppBar(),
            Expanded(
              child: Stack(
                children: [
                  _buildOrangeBackground(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProfileSection(),
                        _buildFormFields(),
                        SizedBox(height: 80), // Space for bottom button
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar),
              SizedBox(width: 8),
              Icon(Icons.wifi),
              SizedBox(width: 8),
              Icon(Icons.battery_full),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFCEC6C5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, size: 24),
          SizedBox(width: 12),
          Text(
            'Personal Data',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF120F0F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrangeBackground() {
    return Container(
      height: 139,
      decoration: BoxDecoration(
        color: Color(0xFFF17228),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 45),
          child: Column(
            children: [
              Container(
                width: 149,
                height: 149,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFF8F1F0),
                    width: 1.096,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/75fecaf9a843216430a51bbf62a53b2a2ddfb1ac'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFB2B2B2)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Color(0xFFF0F0F0),
                      Color(0xFFE0E0E0),
                    ],
                    stops: [0.0, 0.7188, 1.0],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Silver Member',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.star, size: 24, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 91,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              color: Color(0xFF847D79),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFormField('Full Name', 'Frances Swann'),
          SizedBox(height: 12),
          _buildFormField('Date of birth', '19/06/1999'),
          SizedBox(height: 12),
          _buildFormField(
            'Gender',
            'Male',
            suffix: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF101010),
            ),
          ),
          SizedBox(height: 12),
          _buildFormField('Phone', '+1 325-433-7656'),
          SizedBox(height: 12),
          _buildFormField('Email', 'albertstevano@gmail.com'),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String value, {Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF847D79),
            fontFamily: 'Fredoka',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFF1EFE9)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF101010),
                    fontFamily: 'Fredoka',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(17, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF74CA45),
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(120),
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Fredoka',
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
