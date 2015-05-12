# Exercise 4 README

## Installation and Usage

1. Download the [MNIST dataset](https://dl.dropboxusercontent.com/u/663533/da_ex4/mnist.zip).
2. Extract the files of the archieve `mnist.zip` into `input/`.
3. Run `ruby start.rb -p PREPROCESS_MODE`
4. Run `bundle`

### To run **visualize.rb**

1. `brew uninstall imagembrew uninstall pkgconfig`
2. `brew uninstall imagemagick`
3. `brew install imagemagick --build-from-source`
4. `bundle`

## Parameters

+ Preprocess Mode -p PREPROCESS_MODE
 + optional argument, Integer value
 + PREPROCESS_MODE == 0 => No Preprocessing
 + PREPROCESS_MODE == 1 => Run Matlab Preprocessing
