//For Imagespop
import 'package:flutter/material.dart';

class ImagePopup extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImagePopup({super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePopupState createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _goToNextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstImage = _currentIndex == 0;
    final isLastImage = _currentIndex == widget.imageUrls.length - 1;

    return Dialog(
      backgroundColor: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.60,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrls[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isFirstImage)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: _goToPreviousImage,
                      ),
                    if (!isLastImage)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: _goToNextImage,
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
