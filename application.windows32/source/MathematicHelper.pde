public Float frac(Float n, Float d) {
 return n/d; 
}


public Float getX_ternary(Float a, Float b, Float c) {
  return 0.5*frac((2*b+c),(a+b+c));

}

public Float getY_ternary(Float a, Float b, Float c) {

  float heightT = (float) Math.sqrt(3)/2;
  return heightT*frac((c),(a+b+c));

}


      


public double getMax(double[] values){
  double result = Double.NEGATIVE_INFINITY;
  for (int i = 0; i < values.length; i++) {
    result = Math.max(result, values[i]);      
  }
  return result;
}
    
public double getMin(double[] values){
  double result = Double.POSITIVE_INFINITY;
  for (int i = 0; i < values.length; i++) {
    result = Math.min(result, values[i]);      
  }
  return result;
}

public Float getMax(Float[] values){
  Float result = Float.MIN_VALUE;
  for (int i = 0; i < values.length; i++) {
    result = Math.max(result, values[i]);      
  }
  return result;
}
    
public Float getMin(Float[] values){
  Float result = Float.MAX_VALUE;
  for (int i = 0; i < values.length; i++) {
    result = Math.min(result, values[i]);      
  }
  return result;
}

public double[] normalizeLinear(final double[] input, final double min, final double max) {
  double[] result = new double[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0 - min) / (max - min);
  }
  return result;
}


public Float[] normalizeLinear(final Float[] input, final Float min, final Float max) {
  Float[] result = new Float[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0 - min) / (max - min);
  }
  return result;
}

public double[] normalizeLinear(final int[] input, final double min, final double max) {
  double[] result = new double[input.length];
  for (int i = 0; i < input.length; i++) {
     result[i] =  (input[i] * 1.0 - min) / (max - min);
  }
  return result;
}
