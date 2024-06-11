from flask import Flask, request, jsonify
from transformers import DetrImageProcessor, DetrForObjectDetection
from PIL import Image
import io
import torch

app = Flask(__name__)

model_directory = "./"
model = DetrForObjectDetection.from_pretrained(model_directory)
processor = DetrImageProcessor.from_pretrained(model_directory)

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    image = Image.open(file.stream)

    inputs = processor(images=image, return_tensors="pt")

    with torch.no_grad():
        outputs = model(**inputs)
    
    target_sizes = torch.tensor([image.size[::-1]])
    results = processor.post_process_object_detection(outputs, target_sizes=target_sizes)[0]

    predictions = []
    for score, label, box in zip(results["scores"], results["labels"], results["boxes"]):
        if score >= 0.1:
            box = box.tolist()
            predictions.append({
                "score": score.item(),
                "label": model.config.id2label[label.item()],
                "bbox": box
            })
    print(predictions)
    return jsonify(predictions)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
