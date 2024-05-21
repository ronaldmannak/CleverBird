//  Created by B.T. Franklin on 7/27/23

public struct EmbeddingResponse: Codable {

    public struct EmbeddingData: Codable {
        public let object: String
        public let embedding: Vector
        public let index: Int
    }

    public let data: [EmbeddingData]
    public let usage: Usage
}
