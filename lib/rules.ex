defmodule Rules do

  def hasOperator?(%Clauses{formula: x, sign: _}) do
    case x do
      {:and, _, _}     -> true
      {:or, _, _}      -> true
      {:not, _}        -> true
      {:implies, _, _} -> true
      _                -> false  
    end  
  end
  def hasOperator?(_), do: nil  

  def branching?(%Clauses{formula: {:and, _, _}, sign: F}),    do: true
  def branching?(%Clauses{formula: {:or, _, _}, sign: T}),     do: true
  def branching?(%Clauses{formula: {:implies, _, _}, sign: T}), do: true
  def branching?(_), do: false    
 


 # linear rules 
  defp expandLinear(%Clauses{formula: {:not, op}, sign: T}) do 
     [%Clauses{formula: op, sign: T},
       %Clauses{formula: op, sign: F}] 
  end

  defp expandLinear(%Clauses{formula: {:not, op}, sign: F}) do 
      [%Clauses{formula: op, sign: F}, 
                %Clauses{formula: op, sign: T}]  
  end

  defp expandLinear(%Clauses{formula: terms, sign: _s}) do
    case terms do 
      {:and, first, second}    -> 
        [%Tree{value: %Clauses{formula: first, sign: T},
          left: %Tree{value: %Clauses{formula: second, sign: T}}}]
      
      {:or, first, second}     -> 
            [%Tree{value: %Clauses{formula: first, sign: F}, 
            left: %Tree{value: %Clauses{formula: second, sign: F}}}]  
      

      {:implies, first, second} -> 
           [%Tree{value: %Clauses{formula: first, sign: T},
           left: %Tree{value: %Clauses{formula: second, sign: F}}}]  
      
      _                         -> nil 
    end
  end

  # branching rules
  defp expandBranch(%Clauses{formula: terms, sign: _s}) do  
    case terms do 
      {:and, first, second}     -> 
           [%Tree{value: %Clauses{formula: first, sign: F}}, 
          %Tree{value: %Clauses{formula: second, sign: F}}]  
      
      {:or, first, second}      -> 
           [%Tree{value: %Clauses{formula: first, sign: T}}, 
          %Tree{value: %Clauses{formula: second, sign: T}}]  
      
      {:implies, first, second} -> 
          [%Tree{value: %Clauses{formula: first, sign: F}}, 
          %Tree{value: %Clauses{formula: second, sign: T}}]  
      _                          -> nil
    end 
  end 
 
  defp expand(clause) do 
    case branching?(clause) do 
      true  -> expandBranch(clause)
      false -> expandLinear(clause)
    end
  end
  
  def addExpand(current, %Tree{value: v, right: nil, left: l}) when is_nil(l) do
    
    [ head | tail ] = expand(current.value)
    cond do
      Rules.branching?(current.value) -> %Tree{value: v, right: head, left: hd(tail)}
      true ->  %Tree{value: v, right: nil, left: head}
      end
  end 

  def addExpand(clause, %Tree{value: v, right: r, left: l}), do: 
    %Tree{value: v, right: r, left: addExpand(clause, l)}

end
