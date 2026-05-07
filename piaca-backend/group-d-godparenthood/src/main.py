from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Godparenthood API", "status": "running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3004)
