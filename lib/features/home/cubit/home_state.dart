
abstract class HomeState {
  final int tabIndex;
  const HomeState(this.tabIndex);
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(0); 
}

class HomeTabChanged extends HomeState {
  const HomeTabChanged(super.index);
}
