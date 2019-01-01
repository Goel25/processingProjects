class NeuralNetwork {
  int amtOfInputs;
  int amtOfOutputs;
  float[][] inputHidden;
  float[][] hiddenOutput;
  float[] hiddenBiases;
  float[] outputBiases;

  NeuralNetwork(int amtOfInputs_, int amtOfHiddenNodes_, int amtOfOutputs_) {
    amtOfInputs = amtOfInputs_; //How many input nodes
    amtOfOutputs = amtOfOutputs_; //How many output nodes

    inputHidden = create2dArray(amtOfInputs, amtOfHiddenNodes_); //Create random weights
    hiddenOutput = create2dArray(amtOfHiddenNodes_, amtOfOutputs);

    hiddenBiases = randomArray(amtOfHiddenNodes_); //Create random biases
    outputBiases = randomArray(amtOfOutputs);
  }

  float[] predict(float[] inputs) { //Feedforward algorithm to get the outputs from some inputs
    if (inputs.length != amtOfInputs) {
      print("The number of inputs must be the same as when the network was created!");
      noLoop();
    }

    float[] hiddenValues = hiddenBiases.clone(); //The array to hold the value of each hidden node based on the inputs, starting off with the biases so it doesn't have to be added later
    for (int j = 0; j < hiddenValues.length; j++) { //Compute each hidden node
      for (int i = 0; i < inputs.length; i++) {
        hiddenValues[j] += (inputs[i] * inputHidden[i][j]);
      }
    }
    // hiddenValues = hiddenValues.map(x => activateReLu(x)); //Activate each hidden node
    for (int i = 0; i < hiddenValues.length; i++) {
      hiddenValues[i] = activateReLu(hiddenValues[i]);
    }

    float[] outputs = outputBiases.clone(); //The final outputs, starting out with the biases
    for (int j = 0; j < outputs.length; j++) { //Compute each hidden node
      for (int i = 0; i < hiddenValues.length; i++) {
        outputs[j] += (hiddenValues[i] * hiddenOutput[i][j]);
      }
    }
    //let totalOutput = 0;//Implementation of Softmax, not needed for this
    //for (let val of outputs) {
    //  totalOutput += val; //The total of all outputs, to be used for softmax
    //}
    //outputs = outputs.map(x => activateSoftmax(x, totalOutput)); //Activate each output
    return outputs;
  }

  NeuralNetwork crossover(NeuralNetwork other, int type) { //The crossover function, type is what type of crossover to perform
    NeuralNetwork childNN = new NeuralNetwork(amtInputs, amtHidden, amtOutputs); //Create the child

    //Make each array of the child a combination of the parents
    for (int i = 0; i < amtInputs; i++) {
      childNN.inputHidden[i] = crossoverArray(inputHidden[i], other.inputHidden[i], type);
    }
    for (int j = 0; j < amtHidden; j++) {
      childNN.hiddenOutput[j] = crossoverArray(hiddenOutput[j], other.hiddenOutput[j], type);
    }
    childNN.hiddenBiases = crossoverArray(hiddenBiases, other.hiddenBiases, type);
    childNN.outputBiases = crossoverArray(outputBiases, other.outputBiases, type);
    return childNN;
  }

  void mutate(float rate) { //Mutate each gene with a percent chance and mutate it using a certain function
    for (int i = 0; i < inputHidden.length; i++) { //TODO Make these more efficient by only doing one loop
      for (int j = 0; j < inputHidden[i].length; j++) {
        if (Math.random() < rate) inputHidden[i][j] = random(1) * 2 -1;
      }
    }
    for (int i = 0; i < hiddenOutput.length; i++) {
      for (int j = 0; j < hiddenOutput[i].length; j++) {
        if (Math.random() < rate) hiddenOutput[i][j] = random(1) * 2 -1;
      }
    }
    for (int i = 0; i < hiddenBiases.length; i++) {
      if (Math.random() < rate) hiddenBiases[i] = random(1) * 2 -1;
    }
    for (int i = 0; i < outputBiases.length; i++) {
      if (Math.random() < rate) outputBiases[i] = random(1) * 2 -1;
    }
  }
}

float[] crossoverArray(float[] arrA, float[] arrB, int type) {
  if (arrA.length != arrB.length) {
    println("Attempte to crossover arrays of different length!");
    noLoop();
  }

  float[] childArray = new float[arrA.length];
  switch (type) {
  case 0: //Each index has a 50/50 chance of being from either array
    for (int i = 0; i < arrA.length; i++) {
      if (random(1) < 0.5) {
        childArray[i] = arrA[i]; //Instead of this, make it combine the arrays, shuffle them, then only take the first half
      } else {
        childArray[i] = arrB[i];
      }
    }
    break;
  case 1: //Takes first 50% from arrA, second 50% from arrB
    println("DONT USE CASE 1!!!!!!");
    break;
  }
  return childArray;
}

float activateReLu(float n) { //The ReLu activation function
  return max(0, n);
}

float activateSoftmax(float n, float total) {
  return n / total;
}

float[][] create2dArray(int rows, int cols) {
  float[][] arr = new float[rows][cols];
  //let arr = [];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      arr[i][j] = random(1) * 2 - 1; //Randomize each value
    }
  }
  return arr;
}

float[] randomArray(int len) {
  float[] arr = new float[len];
  for (int i = 0; i < len; i++) {
    arr[i] = (random(1) * 2 - 1);
  }
  return arr;
}
