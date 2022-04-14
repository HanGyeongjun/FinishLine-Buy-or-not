//
//  QuestionItem.swift
//  buy-or-not
//
//  Created by leejunmo on 2022/04/13.
//

import SwiftUI

struct QuestionItem: View {
    
    var author: String
    var title: String
    var category: String
    var items: [Options]
    var timestamp: Int
    
    
    @Binding var previewImg: String
    @Binding var previewState: Bool
    @Binding var fromWhere: Bool
    
    @State private var mode: Int = -1
    @State var voteDone: Bool = false
    @State var buttonState: [Bool] = [false, false, false, false]
    
    func voteCount() -> Int {
        var c = 0
        for i in items {
            c += i.votes.count
        }
        return c
    }
    
    var body: some View {
        
        VStack(alignment:.center) {
    
            if (mode == -1) {
                HStack {
                    ZStack {
                        // 보더적용
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(lineWidth: 1)
                            .foregroundColor(Color(hex: "E5E5EA"))
                            .frame(width: 116, height: 116)
                        
                        // 이미지 크기 보정 적용
                        AsyncImage(url: URL(string: items[0].imageURL)) { phase in
                            switch phase {
                            case .empty:
                                Text("이미지 없음")
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 116, maxHeight: 116)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                Text("이미지 없음")
                            }
                        }
                        .frame(width: 116, height: 116)
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            previewImg = items[0].imageURL
                            previewState.toggle()
                        }
                    }
                    Spacer()
                        .frame(width: 12)
                    
                    VStack(alignment:.leading) {
                        Text("\(title)")
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                        HStack {
                            Text(author)
                                .lineLimit(1)
                            Spacer()
                            if(timestamp > 364){
                                Text("\(timestamp/365)년 전")
                            } else if( timestamp>0){
                                Text("\(timestamp)일 전")
                            } else if(timestamp > -59){
                                Text("\(-timestamp)분 전")
                            } else {
                                Text("\(-timestamp/60)시간 전")
                            }
    
                            Text (//
                                "\(Image(systemName: "checkmark.square"))\(voteDone || fromWhere ? voteCount() : voteCount()-1)"
                            )
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        
                        
                    }
                }
                .animation(.easeIn, value: 1)
            } else{
                HStack {
                    ZStack {
                        // 보더적용
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(lineWidth: 1)
                            .foregroundColor(Color(hex: "E5E5EA"))
                            .frame(width: 116, height: 116)
                        
                        // 이미지 크기 보정 적용
                        AsyncImage(url: URL(string: items[mode].imageURL))
                        { phase in
                            switch phase {
                            case .empty:
                                Text("이미지 없음")
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 116, maxHeight: 116)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                Text("이미지 없음")
                            }
                        }
                        .frame(width: 116, height: 116)
                        .cornerRadius(20)
                        .onTapGesture {
                            previewImg = items[mode].imageURL
                            previewState.toggle()
                        }
                    }
                    Spacer()
                    
                    VStack(alignment:.leading) {
                        HStack {
                            Text(items[mode].name)
                                .font(.system(size: 18, weight: .regular))
                            Spacer()
                            Text (
                                "\(Image(systemName: "xmark"))"
                            )
                            .onTapGesture {
                                mode = -1
                                buttonState = [false, false, false, false]
                            }
                        }
                        Spacer()
                        HStack {
                            Text(items[mode].cost)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            LinkURL( url: items[mode].itemURL)
                        }
                        .font(.system(size: 18, weight: .bold))
                    }
                }
                .animation(.easeIn, value: 1)
            }
            Spacer().frame(height: 8)
            ZStack {
                if !fromWhere {
                    VoteButtonView(data: items, fromWhere: false, buttonState: $buttonState, voteDone: $voteDone, mode_:self.$mode)
                } else {
                    VoteButtonView(data: items, fromWhere: true, buttonState: $buttonState, voteDone: $voteDone, mode_:self.$mode)
                }
            }.frame(height: voteDone || fromWhere ? 84 : 42)
            Spacer()
                .frame(height: 8)
        }
        .frame(height: voteDone || fromWhere ? 219.5 : 177.5)
        Divider()
            .padding(.bottom, 17.0)
    }
}
