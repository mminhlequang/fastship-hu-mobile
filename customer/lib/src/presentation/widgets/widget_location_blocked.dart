import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetLocationPermissionBlocked extends StatelessWidget {
  final bool isDenied;
  const WidgetLocationPermissionBlocked({Key? key, this.isDenied = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildLogo(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildLocationImage(),
                      const SizedBox(height: 40),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SvgPicture.string(
        '''<svg width="163" height="32" viewBox="0 0 163 32" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M24.0543 21.9725C23.622 23.087 23.0634 23.9828 21.8398 23.9828H5.83462C5.11989 23.9995 4.53136 23.4359 4.53653 22.7678C4.54274 22.1233 5.09921 21.5813 5.78807 21.5734H17.6167C18.532 21.5734 19.3171 20.9477 19.4898 20.0825L23.5351 2.02008C23.8164 0.844491 24.6356 0.00886863 25.8592 0.00886863L28.6478 0.00197081L29.7338 0H45.1733C46.309 0 47.244 0.900659 47.244 1.99446C47.244 3.08826 46.309 3.98891 45.1733 3.98891H31.6722C31.0619 3.99778 30.4517 4.00567 29.8414 4.01454C29.2694 4.01454 28.7512 4.23822 28.3768 4.59986C28.0034 4.95954 27.7707 5.45815 27.7707 6.00998C27.7707 7.09589 28.6685 7.97783 29.7887 8.00345C29.8062 8.00542 29.8238 8.00542 29.8414 8.00542H34.8703C35.9988 8.02217 36.9142 8.91988 36.9142 9.99889C36.9142 11.0878 35.9822 11.9914 34.8434 11.9934C33.1906 11.9934 29.8828 11.9924 28.2299 11.9914C28.0986 11.9914 27.9165 12.0032 27.7076 12.0554C27.2028 12.1835 26.8822 12.4644 26.7674 12.5767C26.3092 13.0192 26.2068 13.5385 26.1788 13.7198" fill="#12AD2A"/>
          <!-- Add other paths for the complete logo -->
        </svg>''',
        width: 163,
        height: 32,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Find store and item near you ?',
          style: GoogleFonts.fredoka(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Please enter your address to find top restaurants and stores in your area.',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF54535A),
            height: 1.4,
            letterSpacing: 0.16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocationImage() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 361),
      child: AspectRatio(
        aspectRatio: 361 / 193,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/8d9f8a700fe8e4e28d94d69609f0f896ba549e16',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 361),
      child: Column(
        children: [
          _buildActionButton(
            icon:
                '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M20 12C20 16.4183 16.4183 20 12 20C7.58172 20 4 16.4183 4 12C4 7.58172 7.58172 4 12 4C16.4183 4 20 7.58172 20 12Z" stroke="#3C3836" stroke-width="1.5"/>
              <!-- Add other paths for GPS icon -->
            </svg>''',
            label: 'Use current location',
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon:
                '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12.0001 6.32178L12.0001 17.6781M17.6782 11.9999L6.32195 11.9999" stroke="#363853" stroke-width="1.5" stroke-linecap="round"/>
            </svg>''',
            label: 'Add new address',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String icon, required String label}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDEDEDE)),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.string(
                  icon,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.2,
                    letterSpacing: 0.36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
