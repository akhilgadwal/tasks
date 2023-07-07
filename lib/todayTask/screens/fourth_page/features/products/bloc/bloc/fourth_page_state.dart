part of 'fourth_page_bloc.dart';

abstract class FourthPageState extends Equatable {
  const FourthPageState();

  @override
  List<Object> get props => [];
}

abstract class ProductActionState extends FourthPageState {}

class FourthPageInitial extends FourthPageState {}

//
class PostFetchingSuccessfulState extends FourthPageState {
  final List<Product> products;

  const PostFetchingSuccessfulState({required this.products});
}

class PostLoadingState extends FourthPageState {}
