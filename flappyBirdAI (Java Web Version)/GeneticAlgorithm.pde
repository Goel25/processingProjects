class GeneticAlgorithm {
  Bird[] pop;
  int generation;
  float mutRate;

  GeneticAlgorithm(Bird[] population, float mutationRate) { //Maybe pass in function to create random individual
    pop = population;
    generation = 0;
    mutRate = mutationRate;
    //Make ga variables here (population, mutation rate, etc)
  }

  void evolveNextGen() {
    evaluateAllFitness(); //Evaluate fitness
    Bird[] newPop = new Bird[pop.length]; //Create a new population

    for (int i = 0; i < pop.length; i++) {
      int parentAIndex = pickIndex(pop); //Selection
      int parentBIndex = pickIndex(pop);

      int attempt = 0; //Make sure both parents are different
      boolean go = true;
      while (parentAIndex == parentBIndex && go) {
        parentBIndex = pickIndex(pop);
        attempt++;
        if (attempt > 500) {
          println("HAD TO USE DUPLICATE PARENT!!");
          go = false;
          //return;
        }
      }

      Bird child = pop[parentAIndex].crossover(pop[parentBIndex], 0); //Crossover

      child.mutate(mutRate); //Mutation

      newPop[i] = child; //Add to new population
    }
    pop = newPop;
    generation++;
  }

  void evaluateAllFitness() {
    int totalFitness = 0;
    for (Bird p : pop) {
      totalFitness += p.getFitness();
    }
    for (int i = 0; i < pop.length; i++) {
      pop[i].prob = (double) pop[i].fitness / (double) totalFitness;
    }
  }

  void setMutationRate(int n) {
    mutRate = n;
  }
}

int pickIndex(Bird[] list) {
  int index = -1;
  float r = random(1);
  while (r > 0) { 
    index++;
    r -= list[index].prob;
  }
  return index;
}
