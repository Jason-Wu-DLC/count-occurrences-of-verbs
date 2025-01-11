##UN Debate Verbs Analysis and Similarity Search

##Project Overview
This project analyzes the frequency of verbs used in UN General Debate speeches and identifies the most similar debate content to a given sentence using Spark RDD operations and a vector database (Faiss). The task demonstrates the use of distributed computing with Apache Spark and vector similarity search with Faiss.

##Objectives
Verb Frequency Analysis:
Extract and count the most frequently used verbs from the UN General Debates dataset.
Normalize verbs to their simple present tense.
Similarity Search:
Convert debates into vector embeddings.
Find the most similar debate content to a provided query sentence using Faiss.

##Input Files
The project relies on three input files:
un-general-debates.csv: Contains the text of UN General Debate speeches.
all_verbs.txt: A list of verbs.
verb_dict.txt: A dictionary mapping various verb forms to their simple present tense.

##Setup and Execution
Prerequisites
Apache Spark
Faiss
Docker (for setting up the environment)
Python (with necessary libraries installed)

##Steps to Run the Project
Clone the Repository:
git clone https://github.com/yulin-wu-UQ/count-occurrences-of-verbs.git
cd count-occurrences-of-verbs

##Setup Environment:
Run the following commands to set up the Docker environment:

sudo chmod -R 777 nbs/
docker-compose up -d

Upload Files to HDFS:
Identify the namenode container ID and upload files to HDFS:

docker ps
docker exec <container_id> hdfs dfs -put /home/nbs/all_verbs.txt /all_verbs.txt
docker exec <container_id> hdfs dfs -put /home/nbs/verb_dict.txt /verb_dict.txt
docker exec <container_id> hdfs dfs -put /home/nbs/un-general-debates.csv /un-general-debates.csv

Open Jupyter Notebook:
Access the Jupyter Notebook interface at http://<external_IP>:8888 and navigate to the work/nbs/ folder.

Run the Notebook:
Open and execute the provided Jupyter Notebook (verb.ipynb).

##Implementation Details
1. Verb Frequency Analysis
The following steps are performed:
Read Files: Load the dataset, verb list, and verb dictionary into RDDs.
Preprocess Text:
Remove empty lines and punctuation.
Convert text to lowercase.
Extract verbs using the provided verb list.
Normalize Verbs: Convert all verb forms to their simple present tense using the verb dictionary.
Count Frequency: Identify and display the top 10 most frequently used verbs in descending order.

2. Similarity Search
Vectorize Debates: Convert debate texts into vector embeddings.
Build Index: Store these embeddings in a Faiss index.
Search: Query the index with the sentence:
"Global climate change is both a serious threat to our planet and survival."

##Output
Top 10 Verbs: List of verbs and their frequencies.
Most Similar Debate: The debate content most similar to the query sentence

