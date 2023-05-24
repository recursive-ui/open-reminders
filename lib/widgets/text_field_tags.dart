import 'package:flutter/material.dart';
import 'package:open_reminders/constants.dart';
import 'package:textfield_tags/textfield_tags.dart';

class DefaultTextFieldTags extends StatelessWidget {
  const DefaultTextFieldTags({
    super.key,
    required TextfieldTagsController controller,
    required this.distanceToField,
  }) : _controller = controller;

  final TextfieldTagsController _controller;
  final double distanceToField;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: _controller,
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return TextField(
            controller: tec,
            focusNode: fn,
            decoration: InputDecoration(
              labelText: _controller.hasTags ? '' : 'Enter tags...',
              // errorText: error,
              prefixIconConstraints:
                  BoxConstraints(maxWidth: distanceToField * 0.74),
              prefixIcon: tags.isNotEmpty
                  ? SingleChildScrollView(
                      controller: sc,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: tags.map((String tag) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            color: ThemeColors.kPrimary,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#$tag',
                                style: const TextStyle(
                                    color: ThemeColors.kOnPrimary),
                              ),
                              const SizedBox(width: 4.0),
                              InkWell(
                                child: const Icon(
                                  Icons.cancel,
                                  size: 14.0,
                                  color: ThemeColors.kOnPrimary,
                                ),
                                onTap: () {
                                  onTagDelete(tag);
                                },
                              )
                            ],
                          ),
                        );
                      }).toList()),
                    )
                  : null,
            ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          );
        });
      },
    );
  }
}
