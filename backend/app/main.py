from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    return {"message": "Flow AI Inventory API running!"}
