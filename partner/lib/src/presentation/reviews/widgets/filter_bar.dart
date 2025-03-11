import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String selectedDay;
  final String selectedStar;
  final String selectedComment;
  final Function(String) onDaySelected;
  final Function(String) onStarSelected;
  final Function(String) onCommentSelected;

  const FilterBar({
    Key? key,
    required this.selectedDay,
    required this.selectedStar,
    required this.selectedComment,
    required this.onDaySelected,
    required this.onStarSelected,
    required this.onCommentSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              selectedDay,
              onDaySelected,
              Icons.access_time,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton(
              selectedStar,
              onStarSelected,
              Icons.star,
              showIcon: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton(
              selectedComment,
              onCommentSelected,
              Icons.comment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String text,
    Function(String) onPressed,
    IconData icon, {
    bool showIcon = false,
  }) {
    return OutlinedButton(
      onPressed: () => onPressed(text),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          if (showIcon) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
          ],
          const Spacer(),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
} 