package com.frk.dao;

import com.frk.model.Address;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AddressDAO — Data Access Object for user shipping addresses.
 */
public class AddressDAO {

    public boolean add(Address address) {
        // If this is set as default, unset all other defaults first
        if (address.isDefault()) {
            unsetDefaults(address.getUserId());
        }

        String sql = "INSERT INTO addresses (user_id, name, phone, line1, line2, city, state, pincode, is_default) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getName());
            ps.setString(3, address.getPhone());
            ps.setString(4, address.getLine1());
            ps.setString(5, address.getLine2());
            ps.setString(6, address.getCity());
            ps.setString(7, address.getState());
            ps.setString(8, address.getPincode());
            ps.setBoolean(9, address.isDefault());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding address: " + e.getMessage());
            return false;
        }
    }

    public List<Address> getByUser(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    addresses.add(extractAddress(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching addresses: " + e.getMessage());
        }
        return addresses;
    }

    public Address getDefaultAddress(int userId) {
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_default = TRUE LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return extractAddress(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching default address: " + e.getMessage());
        }
        return null;
    }

    public boolean setDefault(int userId, int addressId) {
        unsetDefaults(userId);
        String sql = "UPDATE addresses SET is_default = TRUE WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error setting default address: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int addressId, int userId) {
        String sql = "DELETE FROM addresses WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting address: " + e.getMessage());
            return false;
        }
    }

    private void unsetDefaults(int userId) {
        String sql = "UPDATE addresses SET is_default = FALSE WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error unsetting default addresses: " + e.getMessage());
        }
    }

    private Address extractAddress(ResultSet rs) throws SQLException {
        Address addr = new Address();
        addr.setId(rs.getInt("id"));
        addr.setUserId(rs.getInt("user_id"));
        addr.setName(rs.getString("name"));
        addr.setPhone(rs.getString("phone"));
        addr.setLine1(rs.getString("line1"));
        addr.setLine2(rs.getString("line2"));
        addr.setCity(rs.getString("city"));
        addr.setState(rs.getString("state"));
        addr.setPincode(rs.getString("pincode"));
        addr.setDefault(rs.getBoolean("is_default"));
        return addr;
    }
}
