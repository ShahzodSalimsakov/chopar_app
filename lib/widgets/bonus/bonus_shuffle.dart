import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BonusShuffle extends HookWidget {
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(tr('get_a_gift').toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.blue.shade600,
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.blue.shade600,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                              maxWidth: viewportConstraints.maxWidth),
                          child: Column(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                  tr('mix').toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(width: 2.0, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      // side: BorderSide(width: 20, color: Colors.black)
                                  ),
                                  backgroundColor: Colors.yellow.shade600
                                ),
                              )
                            ],
                          )));
                }))));
  }
}
