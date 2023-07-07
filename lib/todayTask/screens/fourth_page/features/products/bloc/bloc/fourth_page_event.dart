part of 'fourth_page_bloc.dart';

abstract class FourthPageEvent extends Equatable {
  const FourthPageEvent();

  @override
  List<Object> get props => [];
}

class ProductsInitEvent extends FourthPageEvent {}
