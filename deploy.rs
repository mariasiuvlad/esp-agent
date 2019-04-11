use std::io::prelude::*;
use std::net::TcpStream;
use std::error::Error;
use std::fs::File;

fn send(stream: &mut TcpStream) -> Result<usize, std::io::Error> {
    let mut file = File::open("/Users/vlad/Projects/thermo/esp-neo/app.lua")?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let _ = stream.write(contents.len().to_string().as_bytes());
    stream.write(contents.as_bytes())
}

fn run() -> Result<(), Box<Error>> {
    let mut stream = TcpStream::connect("192.168.0.101:8080")?;
    let _ = send(&mut stream);
    let mut buffer = [0; 512];
    stream.read(&mut buffer)?;
    println!("Received: {}", String::from_utf8_lossy(&buffer));
    Ok(())
}

fn main() {
    if let Err(e) = run() {
        println!("Error: {:?}", e);
    }
}
