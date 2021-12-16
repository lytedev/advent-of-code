#![warn(clippy::all, clippy::pedantic)]

mod common;
use common::{day_input, hex_val};

/// # Panics
/// we may panic
pub fn hex_string_to_bytes(s: &String) -> Vec<u8> {
    let bytes = s
        .trim()
        .chars()
        .collect::<Vec<char>>()
        .chunks(2)
        .enumerate()
        .map(|(_, ct)| Ok(hex_val(ct[0])? << 4 | hex_val(ct[1])?))
        .collect::<Result<Vec<u8>, &'static str>>()
        .unwrap();

    println!("Hex String: {}", s);
    bytes.iter().for_each(|b| println!("{:#010b}", b));
    bytes
}

/// # Errors
/// lots of them
/// # Panics
/// whenever I want
pub fn parse_bytes_from_bits(bytes: &[u8], bit_offset: usize, length: u8) -> Result<u64, &'static str> {
    if length > 64 {
        return Err("cannot parse bytes with length > 64");
    }

    // first chunk
    let mut result = 0u64;
    let start = bit_offset;
    let end = bit_offset + usize::from(length);
    let first_offset = start % 8;
    // println!("Start: {}, End: {}", start, end);
    let first_chunk_size = if first_offset + usize::from(length) >= 8 { 8 - (start % 8) } else { end - start };
    let byte_offset = bit_offset / 8;
    /* println!("{:?}", vec![
        first_offset,
        first_chunk_size,
        (8 - first_chunk_size - first_offset),
        usize::from(bytes[byte_offset] << first_offset >> first_offset >> (8 - first_chunk_size - first_offset))
    ]); */
    result += u64::from(bytes[byte_offset] << first_offset >> first_offset >> (8 - first_chunk_size - first_offset));

    // middle bytes
    let num_bytes = (first_offset + usize::from(length) + 7) / 8;
    // println!("Num Bytes: {}, Bit Offset: {}, Length: {}", num_bytes, bit_offset, length);
    for n in 1..(num_bytes - 1) {
        result <<= 8;
        result += u64::from(bytes[byte_offset + n]);
        // println!("After Mid Byte: {:#066b}", result);
    }
    
    // last chunk
    if num_bytes > 1 {
        let bits_so_far = first_chunk_size + ((num_bytes - 2) * 8);
        let bits_left = usize::from(length) - bits_so_far;
        // println!("left: {}", bits_left);
        let cutoff = 8 - bits_left;
        let last_byte_index = byte_offset + num_bytes - 1;
        let byte = bytes[last_byte_index];
        let addend = byte >> cutoff;
        result <<= bits_left;
        result += u64::from(addend);
        // println!("After Last Byte: {:#066b} ({}: {}) {} {:#010b}", result, last_byte_index, byte, cutoff, addend);
    }
    println!(" -> BFROMB Result: {:#066b} ({}->{} [{}] across {} bytes)", result, start, end, length, num_bytes);
    Ok(result)
}

#[derive(Debug)]
struct BITSLiteralValue {
    value: u64
}

#[derive(Debug)]
enum BITSLengthType {
    SubpacketBits,
    SubpacketCount,
}

#[derive(Debug)]
struct BITSOperator {
    length_type: BITSLengthType,
    length: u64,
    subpackets: Vec<BITSPacket>,
}

#[derive(Debug)]
enum BITSValue {
    LiteralValue(BITSLiteralValue),
    Operator(BITSOperator),
}

#[derive(Debug)]
pub struct BITSPacket {
    version: u8,
    packet_type: u8,
    inner: BITSValue,
}

#[derive(Debug)]
struct ParsedPacket {
    bits_parsed: usize,
    packet: BITSPacket,
}

fn parse_packet(bytes: &[u8], packet_start_bit: usize) -> Result<ParsedPacket, &'static str> {
    println!("PARSE PACKET at {}", packet_start_bit);
    let version = parse_bytes_from_bits(bytes, packet_start_bit, 3)?;
    let packet_type = parse_bytes_from_bits(bytes, packet_start_bit + 3, 3)?;
    println!("Processing packet with version {0} of type {2} at bit_index {1}", version, packet_start_bit, packet_type);
    if packet_type == 4 {
        let mut bit_index = packet_start_bit + 6;
        let mut value = 0u64;
        loop {
            let value_segment = parse_bytes_from_bits(bytes, bit_index, 5)?;
            value = (value << 4) & (value_segment & 0b1111);
            println!("Literal Value Segment at {}...", bit_index);
            bit_index += 5;
            if value_segment < 0b10000u64 { break; }
        }
        println!("PARSE PACKET DONE (at {})", packet_start_bit);
        Ok(ParsedPacket {
            bits_parsed: bit_index - packet_start_bit,
            packet: BITSPacket {
                version: version.to_le_bytes()[0],
                packet_type: packet_type.to_le_bytes()[0],
                inner: BITSValue::LiteralValue(BITSLiteralValue { value }),
            }
        })
    } else if parse_bytes_from_bits(bytes, packet_start_bit + 6, 1)? == 0u64 {
        println!("Operator...");
        let length = parse_bytes_from_bits(bytes, packet_start_bit + 7, 15)?;
        println!("Length in bits: {}", length);
        // ignore subpackets parsing in this case
        // 7 bits for the version, type, and length_type header, 15 bits of length, and
        // 8 bits to ensure we're on the next packet boundary
        let mut subpacket_bits = 0usize;
        let mut subpackets = vec![];
        while u64::try_from(subpacket_bits).unwrap() < length {
            let pp = parse_packet(bytes, packet_start_bit + 7 + 15 + subpacket_bits)?;
            subpacket_bits += pp.bits_parsed;
            subpackets.push(pp.packet);
        }
        println!("PARSE PACKET DONE (at {})", packet_start_bit);
        Ok(ParsedPacket {
            bits_parsed: 7 + 15 + subpacket_bits,
            packet: BITSPacket {
                version: version.to_le_bytes()[0],
                packet_type: packet_type.to_le_bytes()[0],
                inner: BITSValue::Operator(BITSOperator {
                    length_type: BITSLengthType::SubpacketCount,
                    length,
                    subpackets,
                }),
            }
        })
    } else {
        println!("Operator...");
        // 11 bits of length
        let length = parse_bytes_from_bits(bytes, packet_start_bit + 7, 11)?;
        println!("Length in subpackets: {}", length);
        let mut bit_index = packet_start_bit + 7 + 11;
        let mut subpackets = vec![];
        for _ in 0..length {
            let pp = parse_packet(bytes, bit_index)?;
            bit_index += pp.bits_parsed;
            subpackets.push(pp.packet);
        }
        println!("PARSE PACKET DONE (at {})", packet_start_bit);
        // 7 bits for the version, type, and length_type header, 11 bits of length, and
        // 8 bits to ensure we're on the next packet boundary
        Ok(ParsedPacket {
            bits_parsed: bit_index - packet_start_bit,
            packet: BITSPacket {
                version: version.to_le_bytes()[0],
                packet_type: packet_type.to_le_bytes()[0],
                inner: BITSValue::Operator(BITSOperator {
                    length_type: BITSLengthType::SubpacketBits,
                    length,
                    subpackets,
                }),
            }
        })
    }
}

/// # Panics
/// anytime I want
pub fn packet_version_sum(packet: BITSPacket) -> u64 {
    // bytes.iter().for_each(|b| println!("{:#010b}", b));
    if let BITSValue::Operator(p) = packet.inner {
        let mut result = 0u64;
        for p in p.subpackets {
            result += packet_version_sum(p);
        }
        result + u64::from(packet.version)
    } else {
        u64::from(packet.version)
    }
}

fn main() {
    let bytes = hex_string_to_bytes(&day_input(16));
    bytes.iter().for_each(|b| println!("{:#010b}", b));
    let packet = parse_packet(&bytes, 0).unwrap().packet;
    // println!("{:#?}", packet);
    let version_sum = packet_version_sum(packet);
    println!("Sum of packet versions: {:?}", version_sum);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn packet_version_sum_examples() {
        let tester = |s: &str| packet_version_sum(parse_packet(&hex_string_to_bytes(&s.to_string()), 0).unwrap().packet);
        assert_eq!(tester("8A004A801A8002F478"), 16);
        assert_eq!(tester("620080001611562C8802118E34"), 12);
        assert_eq!(tester("C0015000016115A2E0802F182340"), 23);
        assert_eq!(tester("A0016C880162017C3686B18A3D4780"), 31);
    }

    #[test]
    fn parse_bytes_from_bits_examples() {
        let v: Vec<u8> = vec![0b0011_0011, 0b0100_1111, 0b1101_1011, 0b1001_1010];
        // assert_eq!(0b1100_1011u8 >> 9u8, 0b0);
        // assert_eq!(0b1100_1011u8 >> 8u8, 0b0);
        assert_eq!(0b1100_1011u8 >> 7u8, 0b1);
        assert_eq!(parse_bytes_from_bits(&v, 2, 1), Ok(0b1));
        assert_eq!(parse_bytes_from_bits(&v, 2, 2), Ok(0b11));
        assert_eq!(parse_bytes_from_bits(&v, 1, 2), Ok(0b01));
        assert_eq!(parse_bytes_from_bits(&v, 0, 3), Ok(0b001));
        assert_eq!(parse_bytes_from_bits(&v, 0, 8), Ok(0b0011_0011u64));
        assert_eq!(parse_bytes_from_bits(&v, 2, 8), Ok(0b1100_1101u64));
        assert_eq!(parse_bytes_from_bits(&v, 6, 8), Ok(0b1101_0011u64));
        assert_eq!(parse_bytes_from_bits(&v, 7, 10), Ok(0b10_1001_1111u64));
        assert_eq!(parse_bytes_from_bits(&v, 7, 3), Ok(0b101u64));
        assert_eq!(parse_bytes_from_bits(&v, 6, 3), Ok(0b110u64));
        assert_eq!(parse_bytes_from_bits(&v, 22, 3), Ok(0b111u64));
        assert_eq!(parse_bytes_from_bits(&v, 7, 20), Ok(0b1010_0111_1110_1101_1100u64));
        assert_eq!(parse_bytes_from_bits(&v, 15, 12), Ok(0b1110_1101_1100u64));
        assert_eq!(parse_bytes_from_bits(&v, 18, 3), Ok(0b011u64));
    }
}
