from transformers import pipeline

classifier = pipeline('sentiment-analysis')

res = classifier('We are very happy to show you the 🤗 Transformers library.')

print(res)