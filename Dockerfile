FROM golang:1.22.5 as base

WORKDIR /app 

COPY go.mod .
# is command se dependencies ko download karenge...ye dependencies go.mod file me defined hoti hain

RUN go mod download
# ye copy aur run command isliye use kiya jata hai taki dependencies ko cache kiya ja sake aur har build me download na karna pade...agar future me dependencies change hoti hain to hi ye command run hogi aur dependencies download hongi

# now copy the source code into the docker image

COPY . .
RUN go build -o main .
# isse image me main naam ka binary file create hoga jo ki humare application ka executable hoga

# ab hum final stage banayenge which will be a distroless image...isme hum upar wali stage me jo binary file create hui hai in the /app directory usko copy karenge 
FROM gcr.io/distroless/base
COPY --from=base /app/main .

COPY --from=base /app/static ./static
# ye humne static folder ko bhi copy kiya hai bcoz static content is not in binary file...ye static content humare application ke liye zaruri hai

EXPOSE 8080

CMD ["./main"]