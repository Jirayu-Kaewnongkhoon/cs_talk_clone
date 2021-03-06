import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),

);

const postInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.orangeAccent
    ),
  ),
);