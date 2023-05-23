//
//  RecipeCard.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        print(self.recipe.label)
    }
    var body: some View {
        
        ZStack {
            AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 217)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(alignment: .bottom) {
                        VStack {
                            HStack {
                                Text(recipe.label)
                                    .font(.subheadline.weight(.heavy))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                
                                if recipe.totalTime != 0 {
                                    Text("\(recipe.totalTime) min")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                               
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 65)
                        .background(.regularMaterial, in: RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                    }
                } placeholder: {
                        ProgressView()
                }
            }
        }
    }
    
struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

    struct RecipeCard_Previews: PreviewProvider {
        static var previews: some View {
            RecipeCard(recipe: Recipe(
                label: "Test",
                image: "https://edamam-product-images.s3.amazonaws.com/web-img/d32/d32b4dc2e7bd9d4d1a24bbced0c89143.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEK7%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIQD%2FE%2FTplM1%2FY6DDlEv0JHn20cpOWoXhlKZLtkd3JwM4fwIgPbIm6cOe4NaNXW5tBchzunbkD6xzHN1qp7zhTpH%2FJqMqwgUI1%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDKWPJkOEka51KXzPmyqWBZwVrRBsqGPAZdKzl9uE1r8e2YyYerGSVNyXYZkg6S4q%2FX%2Bc74zn1mIKNB7S2ukAGNFIg%2FCSbMuMPGZVcDD8KY3hNWrmRWQd0vjig3EBPbZ4KOUdfoOKXT%2FuupPGZSswJaCHbRjWid%2FCoky82FOwHelkUnAksOSUlQNkTs%2BiqzbVOnnzNUF8eCoqw8oGx3bWY4PVMq8N0MqIcHx2ANXH7rdGAIJbGEd0THtu%2Bhvdjn5oBaKz0MPgQJsh5c%2BGE7izdsyjYOqrpyVp4iFrq2F2ks4dzr5Oe812Bq9xQ5JL5nAej2ICt%2BkWG6kmOu2xrdUXHK9pqoJHKJrJS%2FTGLkqBwCO5QmQbBx96F%2FikCq5Df0%2F%2BhIZlc2B5owBuKivXT%2BRSK9dP8QbJIrs595HW7E%2Fr6ZpEPB3LEDIX42ebbmlrxQdT4RGbrprvdK44SFlCEvcSBta95qx1idp1Cs4x9yt3Nh1CyPCUHgRWX%2FSgwEXYy2R9nm%2FmvskUvEd7%2BzV%2Bo8wkn8Bek3snWDBzMKDhgk3kLgaBu1RiB42uHat%2FzgzMWX6dFfjYxqo4mVGBXAheY31nXwkjUhJjCvxmctYWCcwHHpYW6qtyi6NM5JmQnO%2FtO%2FI%2FD9fcreiWztsr61rHqCbZcHKgWYwb9pQgqWde3%2BlyK7bf6ql94gNiKjH5YO3%2FVQ53OtdXCFeREEJebMStf7fy3H85i55P1JtVzaNYKycwmimUDy2ufK4jsUun0arP4asQTL2TTvjzzkbk5PufCG6HFyJsQW8nZ%2BJ1tKs%2BqLf4Cljbvo6salq%2B0vHe8GDP2pbSnq0JGbl8qNTsgTqQD%2FBWyXIWFdooOhtT4pHInBmw2MPgzRRL8fqKVz5DnMdSBAhmKHTSyXM%2BMIGDs6MGOrEBiPdUo6WytVs%2BS2PtwsA1OfKQemF3RTvJ%2FEvSc8OFQFnMOBX%2FPXURxyL%2F279ekfZ8p0YL3vtPXmYYNW95GzJbp9moS0u8n6eTD2lRNeQMjCXqxrV%2BvWo%2BoH2ysD4YrUz87HxD9277s3sXT5b0Q7b65%2BgNSx2rt4hhZJrVZYTw0X2ZYaTjoYPQx2KvY%2FNhoCSeRXmMfVcABF8oyvK0aC0rlnpsNryzXA9wpDnGuP0WHXGU&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230523T143308Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFHLCLMYE5%2F20230523%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=48cb9f921b34131e9b53468d75c5454a2cf31c3cb6895389143cde75f2c8523d",
                ingredientLines:["2 tablespoons bottled fat-free Italian salad dressing", "Dash cayenne pepper"], url: "https://www.apple.com",
                //                ingredients: Food(food: "salad"),
                totalTime: 40))
        }
    }

