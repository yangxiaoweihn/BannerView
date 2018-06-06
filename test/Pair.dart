class Pair<F, S>{
    F first;
    S second;
    Pair(F first, S second) {
        this.first = first;
        this.second = second;
    }
    static Pair<F, S> create<F, S>(F first, S second) {

        return new Pair(first, second);
    }
}