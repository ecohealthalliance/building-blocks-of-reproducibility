## Workshop on data anonymization 

this workshop focuses on statistical techniques for anonymizing data - that is making it difficult to re-identify data. 

Think about harms and final data utility after anonymization.

Step 1: Identify harms for releasing data
Step 2: Identify the context you're providing in your study text
Step 3: Remove direct identifiers - be especially careful with geographies
Step 4: Establish a k-anonymity threshold - typically 3-5 is sufficient. This means that there will be 3-5 data doubles in the 
sample. Again, think about the population you are drawing from and the harms that would come from loss of confidentiality. 
    - Identify quais identifiers
    - Figure out if you make classes or identifiers coarser to increase k
